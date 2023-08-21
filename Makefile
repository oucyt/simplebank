# DB_URL=postgresql://root:root@192.168.29.200:5432/simple_bank?sslmode=disable
DB_URL=postgresql://root:root@localhost:5432/simple_bank?sslmode=disable

postgres:
	docker run -it --rm --name my_postgresql -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=root -d postgres:12.15

createdb:
	docker exec -it my_postgresql createdb --username=root --owner=root simple_bank

dropdb:
	docker exec -it my_postgresql dropdb simple_bank

migrateup:
	3rd/migrate-4.16.2 -path db/migration -database "$(DB_URL)" -verbose up

migratedown:
	3rd/migrate-4.16.2 -path db/migration -database "$(DB_URL)" -verbose down

sqlc:
	sqlc generate
	
# "./..."代表当前目录及其子目录。具体来说，"./"表示当前目录，"..."表示当前目录下的所有子目录。
# 这种写法通常用于指定目标文件或源文件的路径，以便在编译或构建过程中找到所需的文件。
test:
	go test -v -cover ./...

server:
	go run main.go

mock:
	mockgen -package mockdb -destination db/mock/store.go github.com/tianyu/simplebank/db/sqlc Store


# --proto_path=proto：指定.proto文件的搜索路径为proto文件夹。这意味着protoc将在proto文件夹中查找.proto文件。
# --go_out=pb：指定生成Go代码的输出目录为pb文件夹。这将生成的Go代码输出到pb文件夹中。
# --go_opt=paths=source_relative：使用source_relative选项设置Go代码中的导入路径为源文件相对路径。这使得生成的Go代码可以根据源文件的位置正确引用其他生成的Go代码。
# --go-grpc_out=pb：指定生成gRPC代码的输出目录也为pb文件夹。这将生成的gRPC代码输出到pb文件夹中。
# --go-grpc_opt=paths=source_relative：使用source_relative选项设置gRPC代码中的导入路径为源文件相对路径。这使得生成的gRPC代码可以根据源文件的位置正确引用其他生成的Go代码。
# proto/*.proto：指定要编译的.proto文件。在这个例子中，它表示编译proto文件夹中的所有.proto文件。
protoc:
	rm -f pb/*.go
	protoc --proto_path=proto 				   \
		   --go_out=pb 						   \
		   --go_opt=paths=source_relative      \
		   --go-grpc_out=pb 				   \
		   --go-grpc_opt=paths=source_relative \
	proto/*.proto

evans:
	3rd/evans-0.10.11 --host 0.0.0.0 --port 9001 -r repl

.PHONY: postgres createdb dropdb migrateup migratedown sqlc server protoc evans