


#SavorX

aliyun oss


# md-to-pdf

A web service for converting markdown to PDF

## Web UI

For quick experimentation, you can use [the web version](https://md-to-pdf.fly.dev) hosted on [Fly.io](https://fly.io).
Just paste your markdown and download the converted PDF.

Availability of the service is not guaranteed, see [Fly.io status](https://status.flyio.net) when it is down.
If you need guaranteed availability, [deploy it yourself](#deploy).

## API

You can convert markdown by sending a `POST` request to `https://md-to-pdf.fly.dev`.

```shell
curl --data-urlencode 'markdown=# Heading 1' --output md-to-pdf.pdf https://md-to-pdf.fly.dev
```

| Parameter  | Required | Description                                                                                           |
|------------|----------|-------------------------------------------------------------------------------------------------------|
| `markdown` | Required | The markdown content to convert                                                                       |
| `css`      | Optional | CSS styles to apply                                                                                   |
| `engine`   | Optional | The PDF conversion engine, can be `weasyprint`, `wkhtmltopdf` or `pdflatex`, defaults to `weasyprint` |

Send data from files like this:

```shell
curl --data-urlencode "markdown=$(cat example.md)" 
```

## Deploy

A prebuilt con