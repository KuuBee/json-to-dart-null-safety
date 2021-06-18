# JSON to Dart null safety

通过一个 JSON 字符串来生成可以序列化该 JSON 的空安全 `Dart`代码。

# Getting Started

## 线上使用

您可以点击[这里](https://autocode.icu/jsontodart)在线上使用。

## 本地部署

> 使用了 Nextjs 进行开发，更多命令请查看 [https://nextjs.org/](https://nextjs.org/)。

或者您也可以通过 clone 本仓库来进行您的本地部署。

本地部署需要您具有一下环境：

- [Node.js](https://nodejs.org/) 10.13 或更高版本。

通过一下命令进行本地预览。

```bash
git clone https://github.com/KuuBee/json-to-dart-null-safety.git
cd json-to-dart-null-safety
npm i
npm run dev
```

在您的浏览器打开 [http://localhost:3000/jsontodart](http://localhost:3000/jsontodart) 来进行预览。

# 注意事项

- 对于如下结构的 JSON 是不会进行转换的：

```json
[{ "a": 1 }, { "a": 2 }]
{
  "a":[
    [1,2,3],
    [1,2,3],
    [1,2,3],
  ]
}
```

- 如果在使用过程中遇见任何问题，请及时提 issue 好让我及时修复。

