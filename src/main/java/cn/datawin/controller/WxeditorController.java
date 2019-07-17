package cn.datawin.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * Created by hyygavin on 2019/7/16.
 */
@Controller
@RequestMapping("/wxeditor")
public class WxeditorController {

    @RequestMapping("/loadtemp")
    public String loadtemp(String type){
       return "/wxeditor/temp_"+type;
    }


}
