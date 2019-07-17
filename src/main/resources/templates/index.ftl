<!DOCTYPE HTML>
<html>
<head>
    <title>微信编辑器 -leipi.org</title>
    <meta name="keyword" content="">
    <meta name="description" content="">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="author" content="leipi.org">
    <link href="/static/css/bootstrap/css/bootstrap.css" rel="stylesheet" type="text/css"/>
    <!--[if lte IE 6]>
    <link rel="stylesheet" type="text/css" href="/static/css/bootstrap/css/bootstrap-ie6.css">
    <![endif]-->
    <!--[if lte IE 7]>
    <link rel="stylesheet" type="text/css" href="/static/css/bootstrap/css/ie.css">
    <![endif]-->
    <link href="/static/css/site.css" rel="stylesheet" type="text/css"/>
    <link href="/static/css/wwei_editor.css" rel="stylesheet" type="text/css"/>
    <link rel="stylesheet" type="text/css" href="/static/wxeditor/css/jquery.jgrowl.css"/>

    <script type="text/javascript" src="/static/js/jquery-1.7.2.min.js"></script>
    <script type="text/javascript" src="/static/css/bootstrap/js/bootstrap.min.js"></script>
</head>
<body>


<div class="container">

    <div class="row">


        <h4>正文模板样式定义</h4>
        <div>
            <hr/>
            色调：<input class="colorPicker form-control" style="width:70px;" id="custom-color" value="#866EBB"/>
            &nbsp;&nbsp;<label class="checkbox inline"><input type="checkbox" id="replace-color-all"
                                                              value="1">正文换色</label>
            <hr/>
        </div>


        <div class="span5">


            <ul class="nav nav-tabs" id="templateTab">
                <li class="active"><a href="#temp-title" data-type="title">标题</a></li>
                <li><a href="#temp-text" data-type="text">正文</a></li>
                <li><a href="#temp-img" data-type="img">图片</a></li>
                <li><a href="#temp-follow" data-type="follow">吸粉</a></li>
                <li><a href="#temp-scene" data-type="scene">场景</a></li>
                <li><a href="#temp-tpl" data-type="tpl">模板</a></li>
            </ul>

            <div class="tab-content template-content">
                <div id="template-loading" class="hide"><img src="/static/images/loading.gif"> 加载中...</div>
                <div class="tab-pane active" id="temp-title"></div>
                <div class="tab-pane" id="temp-text"></div>
                <div class="tab-pane" id="temp-img"></div>
                <div class="tab-pane" id="temp-follow"></div>
                <div class="tab-pane" id="temp-scene"></div>
                <div class="tab-pane" id="temp-tpl"></div>
            </div><!--tab-content-->


        </div>

        <div class="span7" id="wxcontent">
            <fieldset>
                <div>
				<span class="pull-right">
					<a href="javascript:void(0);" id="copy-editor-html" class="btn btn-primary disabled">复制正文</a>
					<a href="javascript:void(0);" id="clear-editor" class="btn btn btn-danger disabled">清空</a>
				</span>
                    <label>正文</label>
                </div>
                <div style="clear:both"></div>
                <div>
                    <script id="wwei_editor" type="text/plain" style="width:540px;height:600px;"></script>
                </div>
            </fieldset>
        </div>
    </div>

</div> <!-- /container -->


<script src="/static/wxeditor/css/jquery.jgrowl.min.js"></script>
<script type="text/javascript" src="/static/wxeditor/js/less.js"></script>
<script type="text/javascript" src="/static/wxeditor/js/colorPicker.js"></script>
<script type="text/javascript" src="/static/wxeditor/js/ueditor1_4_3/ueditor.config.js"></script>
<script type="text/javascript" src="/static/wxeditor/js/ueditor1_4_3/ueditor.all.min.js"></script>
<script type="text/javascript"
        src="/static/wxeditor/js/ueditor1_4_3/third-party/zeroclipboard/ZeroClipboard.min.js"></script>

<script type="text/javascript" src="/static/wxeditor/js/wwei_editor.js"></script>


<script type="text/javascript">
    var less_parser = new less.Parser;
    ZeroClipboard.config({swfPath: "/static/wxeditor/js/ueditor1_4_3/third-party/zeroclipboard/ZeroClipboard.swf"});
    var wwei_editor = UE.getEditor('wwei_editor');
    //覆盖UEditor中获取路径的方法
    /*UE.Editor.prototype._bkGetActionUrl = UE.Editor.prototype.getActionUrl;
    UE.Editor.prototype.getActionUrl = function(action) {
        if (action == 'uploadimage' || action == 'uploadscrawl' || action == 'listimage') {
            return 'ueditor/ueditorUpload';
        } else {
            return this._bkGetActionUrl.call(this, action);
        }
    };*/
    //加载本地缓存
    /*
     wwei_editor.ready(function(){
     var editor_document = wwei_editor.selection.document;
     if( window.localStorage){
     if(typeof window.localStorage._wweiContent != "undefined"){
     //wwei_editor.setContent(window.localStorage._wweiContent);
     }
     setInterval(function(){
     window.localStorage._wweiContent = wwei_editor.getContent();
     },2000);
     }
     });*/

    $(function () {
        /*模板Tab */
        var dataType = 'title';

        function _loadtemp(dataType) {
            $("#template-loading").show();
            $.ajax({
                type: "POST",
                url: "/wxeditor/loadtemp",
                data: {"type": dataType},
                success: function (data) {
                    $("#template-loading").hide();
                    var tabPane = $("#temp-" + dataType);
                    tabPane.html(data);
                    var _tempLi = tabPane.find('.template-list li');
                    _tempLi.hover(function () {
                        $(this).css({"background-color": "#f5f5f5"});
                    }, function () {
                        $(this).css({"background-color": "#fff"});
                    });
                    _tempLi.click(function () {
                        if (dataType == 'tpl') {
                            var _tempHtml = $(this).find('.tpl-code').html();
                            wwei_editor.setContent("");
                            wwei_editor.execCommand('insertHtml', _tempHtml);
                        } else {
                            var _tempHtml = $(this).html();
                            insertHtml(_tempHtml + "<p><br/></p>");
                        }

                    });
                }
            });
        }

        _loadtemp(dataType);//加载
        //TAB切换
        $('#templateTab a').click(function (e) {
            e.preventDefault();
            $(this).tab('show');

            dataType = $(this).attr("data-type");
            if (dataType) {
                var tabPane = $("#temp-" + dataType);
                if (tabPane.find('.template-list').length <= 0) {
                    _loadtemp(dataType);
                }
            }
        });


        //清空
        $('#clear-editor').click(function () {
            if (confirm('是否确认清空内容，清空后内容将无法恢复')) {
                wwei_editor.setContent("");
            }
        });
        //复制
        var client = new ZeroClipboard($('#copy-editor-html'));
        client.on('ready', function (event) {
            client.on('copy', function (event) {
                event.clipboardData.setData('text/html', getEditorHtml());
                event.clipboardData.setData('text/plain', getEditorHtml());
                showSuccessMessage("已成功复制到剪切板");
            });
        });

        //预览效果
        $("#wx-template-name").blur(function () {
            var val = $(this).val();
            if (val) {
                $("#wxpreview h4").html(val);
            }
        });
        $("#wx-template-dateline").blur(function () {
            var val = $(this).val();
            if (val) {
                $("#wxpreview em").html(val);
            }
        });
        $("#wx-template-cover").blur(function () {
            var val = $(this).val();
            if (val) {
                $("#wxpreview .wxpreimg").html('<img src="' + val + '" width="290" height="209">');
            }
        });

        $("#wx-template-intro").blur(function () {
            var val = $(this).val();
            if (val) {
                $("#wxpreview .wxstr").html(val);
            }
        });

        $("#wx-template-wxid").change(function () {
            var val = $(this).find("option:selected").val(), text = $(this).find("option:selected").text(), url = $(this).find("option:selected").attr("data-url");

            if (text) {
                if (val == 0) text = '';
                if (!url) url = 'javascript:void(0);';
                $("#wxpreview .wxhao").html('<a href="' + url + '" target="_blank">' + text + '</a>');
            }
        });
        //定制效果
        $("#is_show_title").click(function () {
            var cked = $(this).attr("checked");
            if (cked == undefined) {
                $("#wx_show_title").hide();

            } else {
                $("#wx_show_title").show();
            }
        });
        $("#is_show_statis").click(function () {
            var cked = $(this).attr("checked");
            if (cked == undefined) {
                $("#wxpreview .wxfoot").hide();

            } else {
                $("#wxpreview .wxfoot").show();
            }
        });

        //颜色选择
        $('.colorPicker').colorPicker({
            customBG: '#222',
            init: function (elm, colors) { // colors is a different instance (not connected to colorPicker)
                elm.style.backgroundColor = elm.value;
                elm.style.color = colors.rgbaMixCustom.luminance > 0.22 ? '#222' : '#ddd';
            }
        });
    });


</script>


</body>
</html>




