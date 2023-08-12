# DB_URL=postgresql://root:root@192.168.29.200:5432/simple_bank?sslmode=disable
DB_URL=postgresql://root:root@localhost:5432/simple_bank?sslmode=disable

postgres:
	docker run -it --rm --name postgres12 -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=root -d postgres:12.15

createdb:
	docker exec -it postgres12 createdb --username=root --owner=root simple_bank

dropdb:
	docker exec -it postgres12 dropdb simple_bank

migrateup:
	migrate -path db/migration -database "$(DB_URL)" -verbose up

migratedown:
	migrate -path db/migration -database "$(DB_URL)" -verbose down

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

.PHONY: postgres createdb dropdb migrateup migratedown sqlc server