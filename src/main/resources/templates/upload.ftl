<!DOCTYPE html>
<html>
<head>
    <style>
    </style>
</head>
<body>
<form action="/upload_handle"  enctype="multipart/form-data" method="post">
    <table>
        <tr>
            <td>用户姓名:</td>
            <td><input type="text" name="username"/></td>
        </tr>
        <tr>
            <td>密码：</td>
            <td><input type="text" name= "password"/></td>
        </tr>
    </table>
    <input type="file" name="picPath"/>
    <input type="submit" value="提交" />
</form>
</body>

</html>