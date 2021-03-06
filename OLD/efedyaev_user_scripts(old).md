# Егор Федяев - "On My Way"
# Пользовательские сценарии

### Группа: 10 - МИ - 5
### Электронная почта: azurit78@gmail.com
### VK: https://vk.com/georgefed

### [ Сценарий 1 - Регистрация пользователя ]
1. Пользователь нажимает кнопку "Профиль" на главном экране
2. Если у пользователя нет активного аккаунта, система предлагает войти в аккаунт, либо зарегестрироваться
3. Пользователь нажимает кнопку "Регистрация" и переходит на экран регистрации
4. Пользователь вводит логин, с которым будет заходить в систему
5. Пользователь вводит пароль, с которым будет заходить в систему
6. Если выбранный логин уже существует в системе, то пользователю сообщается об этом и предлагается придумать новый логин
7. Если пароль содержит менее 6 символов, система сообщает, что пароль должен быть от 6 до 30 символов и пользователь должен придумать новый пароль
8. Если все введённые данные соответствуют требованиям регистрации, то система приветсутвует пользователя и переводит на главный экран

### [ Сценарий 2 - Вход пользователя ]
1. Пользователь нажимает кнопку "Профиль" на главном экране
2. Если у пользователя нет активного аккаунта, система предлагает войти в аккаунт, либо зарегестрироваться
3. Пользователь нажимает кнопку "Вход" и переходит на экран входа
4. Пользователь вводит логин для входа в систему
5. Пользователь вводит пароль для входа в систему
6. Если логин или пароль не существует в системе, то пользователю сообщается об этом и предлагается повторить попытку входа
7. Если все введённые данные соответствуют требованиям входа, то система приветсутвует пользователя и переводит на главный экран

### [ Сценарий 3 - Создание маршрута ]
1. Пользователь нажимает кнопку "Создать маршрут" на главном экране
2. Пользователь переходит на экран создания маршрута
2. Пользователь нажимает на поле "Введите место назначения"
3. Пользователь переходит к поиску экрану поиска места
4. Если пользователь зарегестрирован в системе, то система предлагает направиться в одно из сохраненных мест
5. Если пользователь зарегестрирован в системе, то система предлагает направиться в одно из недавно посещенных мест
6. Пользователь вводит/выбирает пункт назначения и возвращается на экран создания маршрута
7. Пользователь выбирает способ передвижения: автомобиль/пешеход/общественный транспорт
8. Пользователь выбирает время прибытия в пункт назначения 
9. Пользователь добавляет заметки для пункта назначения
10. Если пользователь нажимает кнопку "Готово", он переходит на главный экран и видит маршрут на карте
11. Если пользователь нажимает кнопку "Добавить новый пункт назначения", сценарий запускается вновь с шага 2

### [ Сценарий 4 - Изменение маршрута ]
1. Если пользователь нажимает кнопку "Добавить пункт назначения" на главном экране, он переходит на экран создания маршрута
2. Пользователь нажимает на поле "Введите место назначения"
3. Пользователь переходит к поиску экрану поиска места
4. Если пользователь зарегестрирован в системе, то система предлагает направиться в одно из сохраненных мест
5. Если пользователь зарегестрирован в системе, то система предлагает направиться в одно из недавно посещенных мест
6. Пользователь вводит/выбирает пункт назначения и возвращается на экран создания маршрута
7. Пользователь выбирает способ передвижения: автомобиль/пешеход/общественный транспорт
8. Пользователь выбирает время прибытия в пункт назначения 
9. Пользователь добавляет заметки для пункта назначения
10. Пользователь нажимает готово
11. Если пользователь нажимает на пункт назначения на главном экране, он может нажать кнопку "Удалить" и убрать пункт назначения из списка

### [ Сценарий 5 - Сохранение маршрутов/пунктов назначения ]
1. Если маршрут существует, пользователь нажимает кнопку "Сохранить" на главном экране
2. Если пользователь не зарегестрирован в системе, система предлагает ему войти, либо зарегестрироваться 
3. Пользователь вводит название маршрута 
4. Если название уже использовано, система сохраняет маршрут с индексом 
5. Система возвращает пользователя на главный экран
6. Если маршрут существует, пользователь нажимает на пункт назначения
7. Пользователь нажимает кнопку сохранить
8. Пользователь вводит название места
9. Если название уже использовано, система сохраняет место с индексом
10. Система возвращает пользователя на главный экран

### [ Сценарий 6 - Использование сохраненного маршрута ]
1. Пользователь нажимает кнопку "Профиль" на главном экране
2. Пользователь нажимает на один из маршрутов
3. Если пользователь хочет удалить маршрут, он нажимает кнопку "Удалить"
4. Если пользователь хочет использовать маршрут, он нажимает кнопку "Применить"
5. Если пользователь до этого следовал другому маршрута, система предлагает отменить, либо подтвердить действие
6. Пользователь нажимает кнопку "Подтвердить"
7. Пользователь возвращается на главный экран с новым активным маршрутом

### [ Сценарий 7 - Следование маршруту ]
1. Пользователь видит активный этап маршрута на карте
2. Пользователь видит активный пункт назначения, предыдущее место нахождения и следующий пункт назначения
3. Пользователь следует маршруту и получает оповещения перед тем, как должен выдвигаться
4. Пользователь видит время отбытия, заметки и время пути
5. Пользователь сдвиграет панель с маршрутом вниз, чтобы увеличить карту
6. Пользователь видит только следующее место наначения и время пути до него 
