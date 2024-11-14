create-db-instance:
	docker run --name postgres-night \
	  -e POSTGRES_USER=fady \
	  -e POSTGRES_PASSWORD=fady \
	  -e POSTGRES_DB=test \
	  -p 5432:5432 \
	  -d postgres

inside-db:
	docker exec -it 586860ce51b9be0da830c1d95306d17129b8a6f6a6a434d03d08f34cc4214f28 psql --u fady -d test