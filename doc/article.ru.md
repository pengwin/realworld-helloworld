# Intro

На часах 2024 год, пришло время писать микросервисный Real World Helloworld. Он будет в какой-то мере близок к real world, но не слишком, потому что реальность всегда страшнее наших фантазий. Все это вдохновлено [JavaEE Hello world Enterprise edition](https://github.com/Hello-World-EE/Java-Hello-World-Enterprise-Edition/tree/master) и прочими подобными юморесками. Все имена и события вымышлены, любые совпадения случайны, мнение автора может не совпадать с его позицией.

По ходу повествования будем рисовать архитектурные диаграммы (с помощью [diagrams](https://diagrams.mingrammer.com/)) и нагружать сервис, с помощью [k6](https://k6.io/). 

# Iteration -1

Начнем с самого приложения. Язык я возьму C#, потому что я на нем пишу, но это незначительная деталь. Приложение у нас будет микросервисом с одним GET endpoint-ом, который будет возвращать строку "Hello, World!".

```csharp
var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();
builder.Logging.ClearProviders(); // disable logging
app.MapGet("/hello-world", () => "Hello World!");
app.Run();
```

Архитектурная диаграмма
![Architecture](./diagrams/output/iteration-1.png)

Запускается сервис с помощью

```shell
ASPNETCORE_URLS=http://::5080 dotnet run --project ./src/HelloWorld/HelloWorld.csproj --configuration Release
```

Нагрузим наш сервис c помощью скрипта k6
    
```javascript
import http from 'k6/http';
export const options = {
  vus: 500,
  iterations: 10000,
};
export default function () {
  http.get('http://localhost:5080/hello-world');
}
```
Запустим нагрузочный тест
```shell
k6 --vus 100 --iterations 5000 run ./load/load-test.js
```

Результаты для моей конфигурации

| Metric | Value |
| --- | --- |
|RPS| 28983.928756/s |
|Avg| 15ms |
|Max| 135.4ms |
|Min| 126.9µs |
|Med| 9.32ms |
|95%| 47.88ms |
|90%| 35.53ms |


