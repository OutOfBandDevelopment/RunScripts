@docker volume create go-pkg

@docker run --rm -it ^
-v %cd%:/usr/src/ ^
-v go-pkg:/go/pkg ^
-w /usr/src/ ^
-p 8080:8080 ^
golang:latest bash %*