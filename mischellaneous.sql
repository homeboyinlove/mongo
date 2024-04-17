1. Найти все заказы данного пользователя:
db.orders.find({ user_id: ObjectId("63de80dd9154810be81acfcf") })
2. Запросить пользователя, которому принадлежит конкретный заказ:
db.users.findOne({ _id: ObjectId("63de80dd9154810be81acfcf") })
3. Запрос находит товар с заданным кратким названием:
db.Catalog.find({ name: "Extra large wheel barrow" })
4. Получить информацию о категории товара с заданным кратким названием:
db.categories.findOne({ name: "Gardening Tools" })
5. Найти все товары в выбранной категории:
db.Catalog.find({ category_ids: ObjectId("63de7f7a208e56eb9e4b7d35") })
6. Запрос извлекает все обзоры, относящиеся к данному товару:
db.reviews.find({ product_id: ObjectId("4c4b1476238d3b4dd5003981") })
7. Отображать отзывы в определенном порядке, например, сортировать результаты запроса по количеству проголосовавших за полезность отзыва:
db.reviews.find().sort({ helpful_votes: -1 })
8. Просмотреть корневые категории, в которых нет товаров:
db.categories.find({ parent_id: { $exists: false } })
9. Найти всех пользователей, проживающих в заданном городе и по диапазону почтовых индексов:
db.users.find({
  "addresses.city": "Springfield",
  "addresses.zip": { $gte: 62000, $lte: 62999 }
})

10. Запрос на получение отзывов данного пользователя, содержащих в тексте слово best или worst (без учета регистра).
    db.reviews.find({
  user_id: ObjectId('661124e7d781ee40039f990c'),
  text: { $regex: /best|worst/i }
})

11. Построить составной индекс по артикулу и дате покупки:
db.orders.createIndex({ "line_items.sku": 1, "created_at": 1 })
12. Запрос на поиск всех товаров, принадлежащих хотя бы одной из категорий:
db.Catalog.find({ category_ids: { $exists: true, $ne: [] } })


13. Поиск товаров либо синего цвета либо произведенных выбранной компанией:
db.Catalog.find({
  $or: [
    { "details.color": "blue" },
    { "details.manufactured": "Acme" }
  ]
})
14. Найти все товары, имеющие одновременно теги gift(подарок) и тег garden(сад):
db.Catalog.find({ tags: { $all: ["gift", "garden"] } })
15. Поиск всех товаров производства фирмы ACME без тега gardening (садоводство):
db.Catalog.find({
  "details.manufactured": "Acme",
  tags: { $ne: "gardening" }
})

