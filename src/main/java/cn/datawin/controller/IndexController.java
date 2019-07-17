package cn.datawin.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * Created by hyygavin on 2019/7/16.
 */
@Controller
public class IndexController {

    @RequestMapping("/")
    public  String index(){
        return "index";
    }
}
