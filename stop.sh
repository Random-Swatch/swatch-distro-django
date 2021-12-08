echo -e "\nStopping swatch UI"
echo "======================="
docker container stop `cat ui.pid`
docker container rm `cat ui.pid`

echo -e "\nStopping swatch server"
echo "==========================="
docker container stop `cat server.pid`
docker container rm `cat server.pid`

rm *.pid