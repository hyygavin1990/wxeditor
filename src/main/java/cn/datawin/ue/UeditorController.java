package cn.datawin.ue;

import org.springframework.stereotype.Controller;
import com.baidu.ueditor.ActionEnter;
import org.springframework.util.ClassUtils;
import org.springframework.util.ResourceUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.FileNotFoundException;
import java.io.UnsupportedEncodingException;

/**
 * Created by hyygavin on 2019/7/16.
 */
@RestController
@RequestMapping("/ue")
public class UeditorController {

    @RequestMapping("/upload")
    public String upload(HttpServletRequest request, HttpServletResponse response) throws UnsupportedEncodingException, FileNotFoundException {
//        String path = ResourceUtils.getURL("classpath:").getPath().substring(1);
        String path = "D:\\tools\\wamp\\www\\ue\\";
        return new UeditorActionEnter( request, path ).exec() ;
    }
}



