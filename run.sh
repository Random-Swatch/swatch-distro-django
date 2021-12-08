rm -rf swatch*

echo "Downloading swatch server"
echo "========================="
git clone https://github.com/Random-Swatch/swatch_server_django.git

echo -e "\nDownloading swatch UI"
echo "========================="
git clone https://github.com/Random-Swatch/swatch-ui.git

cd swatch_server_django

echo -e "\nBuilding swatch server"
echo "======================"
docker build -t swatch/server_django:0.0.1 .

echo -e "\n>> Starting swatch server"
docker run -p 8007:8007 -d swatch/server_django:0.0.1 >> ../server.pid

cd ../swatch-ui

echo -e "\nBuilding swatch UI"
echo "=================="
docker build -t swatch/ui:0.0.1 .

echo -e "\n>>> Starting swatch UI"
docker run -p 3000:3000 -d swatch/ui:0.0.1 >> ../ui.pid

echo -e "\nDone: http://localhost:3000/"

cd ..

rm -rf swatch*