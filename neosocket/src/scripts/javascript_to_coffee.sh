for f in *.coffee; do
# js2coffee "$f" > "${f%.js}.coffee"
mv "$f" "../models_sequelize"
# mv -- "$f" "${f%.js}.coffee"
done
