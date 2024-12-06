create-db-instance:
	docker run --name postgres-night \
	  -e POSTGRES_USER=fady \
	  -e POSTGRES_PASSWORD=fady \
	  -e POSTGRES_DB=test \
	  -p 5432:5432 \
	  -d postgres

inside-db:
	docker start ed95551d51957e3fe6becc16033bf3c80468e2a4bb93f83fc340e02d772f9184
	docker exec -it ed95551d51957e3fe6becc16033bf3c80468e2a4bb93f83fc340e02d772f9184 psql --u fady -d test