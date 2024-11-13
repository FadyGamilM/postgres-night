create-db-instance:
	docker run --name postgres-night \
	  -e POSTGRES_USER=fady \
	  -e POSTGRES_PASSWORD=fady \
	  -e POSTGRES_DB=test \
	  -p 5432:5432 \
	  -d postgres
