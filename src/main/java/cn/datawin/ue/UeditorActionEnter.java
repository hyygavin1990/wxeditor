package cn.datawin.ue;

import com.baidu.ueditor.ActionEnter;
import com.baidu.ueditor.ConfigManager;
import com.baidu.ueditor.define.ActionMap;
import com.baidu.ueditor.define.AppInfo;
import com.baidu.ueditor.define.BaseState;
import com.baidu.ueditor.define.State;
import com.baidu.ueditor.hunter.FileManager;
import com.baidu.ueditor.hunter.ImageHunter;
import com.baidu.ueditor.upload.Uploader;
import org.apache.commons.io.FileUtils;
import org.json.JSONObject;
import org.springframework.util.ResourceUtils;

import javax.servlet.http.HttpServletRequest;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.Iterator;
import java.util.Map;

public class UeditorActionEnter extends ActionEnter {
    private HttpServletRequest request = null;
    private String rootPath = null;
    private String contextPath = null;
    private String actionType = null;
    private ConfigManager configManager = null;
    private String configPath="config.json";//你项目里ueditor的config路径
    
    public UeditorActionEnter(HttpServletRequest request, String rootPath) {
        super(request, rootPath);
        this.request = request;
        this.rootPath = rootPath;
        this.actionType = request.getParameter("action");
        this.contextPath = request.getContextPath();
        //this.configManager = ConfigManager.getInstance(this.rootPath, this.contextPath, request.getRequestURI());
        this.configManager = ConfigManager.getInstance(this.rootPath, this.contextPath, configPath);//自定义
        //重写configManager.getAllConfig()的配置
        //System.out.println("上传路径: "+ this.rootPath + request.getRequestURI().substring( contextPath.length() ));
//        String json=request.getParameter("json");
		try {
			File file = ResourceUtils.getFile("classpath:config.json");
			String json = FileUtils.readFileToString(file);
			json = json.replaceAll("/\\*(.*)\\*/","");

			if(json!=null&&json.length()>0&&this.configManager!=null){
				this.rewriteConfigManager(new JSONObject(json));
			}
		} catch (IOException e) {
			e.printStackTrace();
		}


	}
    public String exec () {
		
		String callbackName = this.request.getParameter("callback");
		//System.out.println("callback=="+callbackName);
		if ( callbackName != null ) {
 
			if ( !validCallbackName( callbackName ) ) {
				return new BaseState( false, AppInfo.ILLEGAL ).toJSONString();
			}
			
			return callbackName+"("+this.invoke()+");";
			
		} else {
			return this.invoke();
		}
 
	}
    public String invoke() {
		if ( actionType == null || !ActionMap.mapping.containsKey( actionType ) ) {
			return new BaseState( false, AppInfo.INVALID_ACTION ).toJSONString();
		}
		
		if ( this.configManager == null || !this.configManager.valid() ) {
			return new BaseState( false, AppInfo.CONFIG_ERROR ).toJSONString();
		}
		
		State state = null;
		
		int actionCode = ActionMap.getType( this.actionType );
		
		Map<String, Object> conf = null;
		//System.out.println("actionCode=="+actionCode);
		switch ( actionCode ) {
		
			case ActionMap.CONFIG:
				return this.configManager.getAllConfig().toString();
				
			case ActionMap.UPLOAD_IMAGE:
			case ActionMap.UPLOAD_SCRAWL:
			case ActionMap.UPLOAD_VIDEO:
			case ActionMap.UPLOAD_FILE:
				//System.out.println(1111);
				conf = this.configManager.getConfig( actionCode );
				state = new Uploader( request, conf ).doExec();
				break;
				
			case ActionMap.CATCH_IMAGE:
				conf = configManager.getConfig( actionCode );
				String[] list = this.request.getParameterValues( (String)conf.get( "fieldName" ) );
				state = new ImageHunter( conf ).capture( list );
				break;
				
			case ActionMap.LIST_IMAGE:
			case ActionMap.LIST_FILE:
				conf = configManager.getConfig( actionCode );
				int start = this.getStartIndex();
				state = new FileManager( conf ).listFile( start );
				break;
				
		}
		
		return state.toJSONString();
		
	}
	
 
	/**
	 * 重写配置
	 * @param json
	 * @return
	 */
	private void rewriteConfigManager(JSONObject json){
		Iterator<?> keys=json.keys();
		while(keys.hasNext()){
			Object key=keys.next();
//			System.out.println(key.toString()+"========="+json.get(key.toString()));
			this.configManager.getAllConfig().put(key.toString(), json.get(key.toString()));
		}
	}
}