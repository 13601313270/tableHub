<!DOCTYPE html>
<html>
<head>
    <meta name="viewport" content="width=device-width,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no,minimal-ui">
    <link href="//cdn.bootcss.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
    <script type="application/javascript" src="//cdn.bootcss.com/jquery/3.2.1/jquery.js"></script>
    <script type="application/javascript" src="//cdn.bootcss.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
</head>
<body>
{include file="commonModule/head.mod.tpl" type=1}
这个是后台模板
<section>
    {block name=hehe}{/block}
</section>
<section>
    {block name=body}{/block}
</section>
{include file="commonModule/bottom.mod.tpl"}
</body>
</html>