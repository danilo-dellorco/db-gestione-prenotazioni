all:
		gcc client.c -o client -I/usr/include/mysql -L/usr/local/mysql/lib -lmysqlclient
clean:
		-rm client