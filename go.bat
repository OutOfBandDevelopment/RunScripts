@docker volume create go-pkg
@docker volume create go-build-cache
@docker run --rm -it ^
-v %cd%:/usr/src/ ^
-v go-pkg:/go/pkg ^
-v go-build-cache:/root/.cache/go-build/ ^
-w /usr/src/ ^
-p 8080:8080 ^
golang:latest go %*