package main

import (
	"log"

	"github.com/button-tech/utils-send-raw-tx-tool/server/handlers"
	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
)

func main() {

	r := gin.New()

	r.Use(cors.Default())

	gin.SetMode(gin.ReleaseMode)

	api := r.Group("/api/v1")

	api.GET("/info", handlers.GetInfo)

	api.POST("/send", handlers.Send)

	// TON testnet
	api.POST("/sendGrams", handlers.SendGrams)

	api.POST("/signMessageHash", handlers.SigningMessageHash)

	if err := r.Run(":8080"); err != nil {
		log.Fatal(err)
	}
}
