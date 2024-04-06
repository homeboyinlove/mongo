// Уникальный идентификатор пользователя, чьи данные нужно обновить
var userId = ObjectId('66115298d781ee40039f991d');

// Новый почтовый индекс
var newZipCode = 55555;

// Выполнение операции обновления
db.users.updateOne(
    { "_id": userId, "addresses.name": "home" }, // Фильтр для нахождения нужного документа
    { $set: { "addresses.$.zip": newZipCode } }  // Обновление почтового индекса в массиве addresses
);
