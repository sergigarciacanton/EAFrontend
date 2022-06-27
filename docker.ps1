flutter build web --dart-define=API_URL=https://eaapi.chickenkiller.com
docker build -t paubaguer/ea-frontend:latest .
docker push paubaguer/ea-frontend:latest