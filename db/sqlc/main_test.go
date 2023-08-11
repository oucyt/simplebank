package sqlc

import (
	"database/sql"
	"log"
	"os"
	"testing"

	_ "github.com/lib/pq"
	"github.com/tianyu/simplebank/util"
)

var testQueries *Queries
var testDB *sql.DB

// 方法签名 func TestMain(m *testing.M){}
// 作用		用于package下的所有单元测试额外的设置（setup）或拆卸（teardown），类似Junit中的@BeforeClass和@AfterClass
func TestMain(m *testing.M) {
	// log.Fatal("TestMain 被执行了")
	config, err := util.LoadConfig("../..")
	if err != nil {
		log.Fatal("cannot load config:", err)
	}
	testDB, err = sql.Open(config.DBDriver, config.DBSource)
	if err != nil {
		log.Fatal("cannot connect to db:", err)
	}

	testQueries = New(testDB)

	os.Exit(m.Run())
}
