1. Обновить почтовый индекс пользователя модификацией замены.
// Уникальный идентификатор пользователя, чьи данные нужно обновить
var userId = ObjectId('66115298d781ee40039f991d');

// Новый почтовый индекс
var newZipCode = 55555;

// Выполнение операции обновления
db.users.updateOne(
    { "_id": userId, "addresses.name": "home" }, // Фильтр для нахождения нужного документа
    { $set: { "addresses.$.zip": newZipCode } }  // Обновление почтового индекса в массиве addresses
);


2.Обновить электронный адрес пользователя путем направленного обновления
// Уникальный идентификатор пользователя, чьи данные нужно обновить
var userId = ObjectId('66115298d781ee40039f991d');

// Новый электронный адрес
var newEmailAddress = "marynewgardener@gmail.com";

// Выполнение операции направленного обновления
db.users.updateOne(
    { "_id": userId }, // Фильтр для нахождения нужного документа
    { $set: { "email": newEmailAddress } } // Обновление электронного адреса
);

3.Добавить новый адрес в список адресов путем замены документа

db.users.updateOne(
    { "_id": ObjectId('66115298d781ee40039f991d') },
    {
        $push: {
            "addresses": {
                "name": "work",
                "street": "1 E. 23rd Street",
                "city": "New York",
                "state": "NY",
                "zip": 10010
            }
        }
    }
);


// Уникальный идентификатор пользователя
var userId = ObjectId('66115298d781ee40039f991d');

// Новый адрес
var newAddress = {
    name: 'summer_house',
    street: '123 Beachfront Avenue',
    city: 'Springfield',
    state: 'IL',
    zip: 62701
};
/////////////////////////////////////////////////////////////////// удаляет остальные данные о пользователе
// Замена документа пользователя с добавлением нового адреса
db.users.replaceOne(
    { "_id": userId },
    {
        // Существующие поля пользователя оставляем без изменений
        // Добавляем новый адрес в список addresses
        "addresses": [
            // Перечисляем существующие адреса
            // Добавляем новый адрес
            ...db.users.findOne({ "_id": userId }).addresses,
            newAddress
        ]
    }
);


4.Добавить новый адрес в список адресов путем направленного обновления

db.users.updateOne(
    { "_id": ObjectId('66115298d781ee40039f991d') },
    {
        $addToSet: {
            "addresses": {
                "name": "work",
                "street": "123 Elm Street",
                "city": "Springfield",
                "state": "IL",
                "zip": 62701
            }
        }
    }
);


5. Обновить средний рейтинг товара при добавлении отзыва

// Агрегируем отзывы для каждого товара, вычисляем средний рейтинг и общее количество отзывов.
var aggregationPipeline = [
  {
    $group: {
      _id: "$product_id",
      total_reviews: { $sum: 1 },
      average_rating: { $avg: "$rating" }
    }
  }
];

// Выполняем агрегацию.
var results = db.reviews.aggregate(aggregationPipeline);

// Обновляем каждый товар в коллекции `Catalog` на основе результатов агрегации.
results.forEach(function(result) {
  db.Catalog.updateOne(
    { _id: result._id },
    { 
      $set: { 
        average_review: result.average_rating,
        total_reviews: result.total_reviews
      } 
    }
  );
});
6. Обновить название категории, включая документы – потомки

// Указываем _id категории, название которой нужно обновить
var categoryIdToUpdate = ObjectId("63de7f7a208e56eb9e4b7d35");

// Указываем новое название категории
var newCategoryName = "Gardening Tools";

// Обновляем название указанной категории
db.categories.updateOne(
    { _id: categoryIdToUpdate },
    { $set: { name: newCategoryName } }
);

// Обновляем название всех категорий-потомков
var updatedDescendants = 1;
while (updatedDescendants > 0) {
    // Обновляем название всех категорий, чьи родительские категории имеют указанный _id
    var result = db.categories.updateMany(
        { "ancestors._id": categoryIdToUpdate },
        { $set: { "ancestors.$.name": newCategoryName } }
    );

    // Проверяем количество обновленных документов
    updatedDescendants = result.modifiedCount;
}


7.// Предположим, что у нас есть переменные reviewId и newVoterId, содержащие _id отзыва и нового пользователя соответственно.
var reviewId = '661124e7d781ee40039f990b';
var newVoterId = '66166830c8cb2532fd4d1f40'; // ID нового голосующего пользователя https://observablehq.com/@hugodf/mongodb-objectid-generator

db.reviews.updateOne(
  { 
    _id: ObjectId(reviewId),
    voter_ids: { $nin: [ObjectId(newVoterId)] } // Проверка, что новый голосующий не существует в массиве voter_ids
  },
  {
    $inc: { helpful_votes: 1 },
    $addToSet: { voter_ids: ObjectId(newVoterId) }
  }
);

