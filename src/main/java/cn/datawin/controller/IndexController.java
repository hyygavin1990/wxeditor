package cn.datawin.controller;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileItemFactory;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import java.io.File;
import java.util.Iterator;
import java.util.List;

/**
 * Created by hyygavin on 2019/7/16.
 */
@Controller
public class IndexController {

    @RequestMapping("/")
    public  String index(){
        return "index";
    }

    @RequestMapping("/upload")
    public  String upload(){
        return "upload";
    }

    @RequestMapping("/upload_handle")
    public  String upload_handle(HttpServletRequest request, Model model) throws Exception {
        boolean isMultipart = ServletFileUpload.isMultipartContent(request);
        //当enctype="multipart/form-data"并且method是post时，isMultipart为真
        if(isMultipart){
            FileItemFactory factory = new DiskFileItemFactory();
            ServletFileUpload upload = new ServletFileUpload(factory);
            //转换请求对象
            List<FileItem> items = null;
            items=upload.parseRequest(request);
            Iterator<FileItem> iterator = items.iterator();
            while(iterator.hasNext()){
                FileItem item = iterator.next();
                //保存上传文件
                if(item.isFormField()){
                    //处理普通文本字段
                    String fieldName = item.getFieldName();
                    if(fieldName.equals("username")){
                        System.out.println("username =" +item.getString());
                        model.addAttribute("username",item.getString());
                    }else if(fieldName.equals("password")){
                        System.out.println("password =" +item.getString());
                        model.addAttribute("password",item.getString());
                    }
                }else{
                    System.out.println(item.getName());
                    File uploadfile = new File("D:/image/",item.getName());
                    item.write(uploadfile);
                    model.addAttribute("isupload","success");
                }
            }
        }

        return "success";
    }
}
