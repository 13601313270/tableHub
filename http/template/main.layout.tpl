<!DOCTYPE html>
<html>
<head>
    <meta name="viewport" content="width=device-width,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no,minimal-ui">
    <link href="//cdn.bootcss.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
    <script type="application/javascript" src="//cdn.bootcss.com/jquery/3.2.1/jquery.js"></script>
    <script type="application/javascript" src="//cdn.bootcss.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
</head>
<body>
<div class="container-fluid">
    <header class="row">
        <div class="col-xs-12">
            {include file="commonModule/head.mod.tpl" type=1}
        </div>
    </header>
    <nav class="row">
        <div class="col-xs-12">
            {block name=nav}{/block}
        </div>
    </nav>
    <section class="row">
        <div class="col-xs-12">
            {block name=body}{/block}
        </div>
    </section>
    <style>
        .container-fluid>footer{
            padding: 0;
        }
    </style>
    <footer class="row">
        <div class="col-xs-12">
            {include file="commonModule/bottom.mod.tpl"}
        </div>
    </footer>
</div>
</body>
</html>