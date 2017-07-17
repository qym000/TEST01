(function($) {
	$.fn.fileupload = function (options, param) {
		// 若options为string类型,则调用方法;
		if (typeof options == 'string'){
			return $.fn.fileupload.methods[options](this, param);
		}
		options = options || {};
		//初始化组件;
		return this.each(function(){    
			var id = $(this).attr("id");        
			var opts ;        
			var data = $.data(this,"fileupload");
			// 是否已绑定到元素,没有则绑定;
			if (data) {      
				opts = $.extend(data.options, options);
				create(this);
			} else {    
				// 解析options;
				opts = $.extend( {}, $.fn.fileupload.defaults,$.fn.fileupload.parseOptions(this), options);
				data = $.data(this,"fileupload", {
					options : opts            
				});
				create(this);
			}               
		});
	}
	
	/**
	 * 构建html元素及绑定点击事件
	 */
	function create(target) {
		var opts = $.data(target,'fileupload').options;
		// 路径文本只读
		$(target).before('<input type="file" id="' + opts.fileElementId + '" name="' + opts.fileElementId + '" style="display:none;"/>');
		$(target).before('<img id="' + $(target).attr("id") + '_tmpImg" dynsrc="" src="" style="display:none" />');
		$(target).attr("readonly","readonly").val("点击选择文件").removeClass().addClass("myui-fileupload");
		$(target).attr("runsta","free");
		$(target).after('<a id="' +$(target).attr("id")+ '_uploadBtn" href="javascript:void(0)" class="myui-fileupload-btn">上传</a>');
		
		// 文件选择文本框点击事件
		$(target).blind("click",function(e){
			var runsta = $(this).attr("runsta");
			if (runsta == "free") {
				$("#" + opts.fileElementId).click();
			}
		});
		
		// 文件上传file元素change事件
		$("#" + opts.fileElementId).bind("change",function(e){
			var path = $(this).val();
			$(target).val(path);
		});
		
		// 文件上传按钮点击事件
		$("#" + $(target).attr("id")+"_uploadBtn").bind("click",function(e){
			var runsta = $(this).attr("runsta");
			if (runsta == "busy") {
				alert('文件正在上传,请稍后');
				return;
			}
			var file = document.getElementById(opts.fileElementId);
			if (file.value == "") {
				alert("请先选择文件后再上传");
				return;
			}
			if (!checkFileSize(target)) {
				alert("文件大小超出指定范围");
				return;
			}
			if (!checkFileType(target)) {
				alert("文件格式不正确");
				return;
			}
			$.ajaxFileUpload({
				url : opts.url, // 用于文件上传的服务器端请求地址
				secureuri : opts.secureuri, // 一般设置为false
	            fileElementId : opts.fileElementId, // 文件上传DOM元素的id属性
	            dataType : opts.dataType, // 返回值类型 一般设置为json
	            success : function(data, status){
	            	opts.onUploadSuccess.call(target, data, status);
	            },
	            error : function(data,status,e) {
	            	opts.onUploadError.call(target,data,status,e);
	            }
			});
		});
	}
	
	/**
	 * 验证文件类型是否符合要求
	 */
	function checkFileType(target) {
		var opts = $.data(target,'fileupload').options;
		if (opts.fileType == null || opts.fileType.length == 0) {
			return true;
		}
		var path = document.getElementById(opts.fileElementId).value;
		var fileType = path.substring(path.lastIndexOf(".") + 1, path.length).toUpperCase();
		var isCorrect = false;
		for (var i = 0; i < opts.fileType.length; i++) {
			if (opts.fileType[i].toUpperCase() == fileType) {
				isCorrect = true;
				break;
			}
		}
		return isCorrect;
	}
	
	/**
	 * 验证文件大小是否符合要求
	 */
	function checkFileSize(target) {
		var opts = $.data(target,'fileupload').options;
		// 判断浏览器类型
		var  browserType = null;  
	    var ua = window.navigator.userAgent;  
		if (ua.indexOf("MSIE")>=1){  
			browserType = "IE";  
		}else if(ua.indexOf("Firefox")>=1){  
			browserType = "FF";  
		}else if(ua.indexOf("Chrome")>=1){  
			browserType = "CR";  
		}  
		var filesize = 0;
		var obj_file = document.getElementById(opts.fileElementId);  
		// 不同浏览器获取文件大小方式不同
		if(browserType == "FF" || browserType == "CR"){  
			filesize = obj_file.files[0].size;  
		}else if(browserType == "EE"){  
			var obj_img = document.getElementById($(target).attr("id") + '_tmpImg');  
			obj_img.dynsrc = obj_file.value;  
			filesize = obj_img.fileSize;  
		}else{  
			alert("浏览器不支持计算文件大小");  
		    return true;  
		}  
		if(filesize == -1){  
			alert("浏览器不支持计算文件大小");  
			return true;  
		}else if(filesize > maxsize){  
			return false;  
		}else{  
			return true;  
		}  

	}
	
	/**
	 * myui-fileupload默认选项
	 */
	$.fn.fileupload.defaults = {
		url : "", // 上传文件的请求路径
		data : null,
		fileElementId : "", // 上传文件的ID
		secureuri : false, // 安全路径,防止浏览器阻止javascript脚本
		dataType : "text/json", // 请求返回的数据类型
		fileSize : 1024*1024*10, // 上传文件大小限制,默认10M
		fileType : null, // 允许文件的类型,数组表示,不区分大小写,如["xls","xlsx","csv"]
		showProgress : false, // 是否显示进度条
		onUploadSuccess : function(data,status){} // 上传完成后回调函数
		onUploadError : function(data,status,e){}
	}
	
	/**
	 * 对用户公开的方法
	 */
	$.fn.fileupload.methods = {
		// 获取选项对象
		options : function (jq) {
			return $.data(jq[0], "fileupload").options;
		},
		// 获取上传文件路径
		getFilePath : function (jq) {
			var opts = $(jq).fileupload("options");
			return opts.data;
		},
		// 获取文件名
		getFileName : function (jq){
			return getValue(jq[0]);
		},
		// 重置
		reset : function (jq) {
			return jq.each(function(){
				reset(this);
			});
		}
	}
	
	/**
	 * 解析options
	 */
	$.fn.fileupload.parseOptions = function(target) {    
		var t = $(target);
		// 可直接使用xml属性设置的可用选项
		return $.extend({},$.parser.parseOptions(target,["fileElementId","url","dataType","fileSize","fileType","showProgress","showType","complateShow","beforeSend","success"]));//解析 data-options 中的初始化参数};
	}
	
})(jQuery);


/**
 *	jQuery.fileupload.js
 */
jQuery.extend({
	

    createUploadIframe: function(id, uri)
	{
			//create frame
            var frameId = 'jUploadFrame' + id;
            var iframeHtml = '<iframe id="' + frameId + '" name="' + frameId + '" style="position:absolute; top:-9999px; left:-9999px"';
			if(window.ActiveXObject)
			{
                if(typeof uri== 'boolean'){
					iframeHtml += ' src="' + 'javascript:false' + '"';

                }
                else if(typeof uri== 'string'){
					iframeHtml += ' src="' + uri + '"';

                }	
			}
			iframeHtml += ' />';
			jQuery(iframeHtml).appendTo(document.body);

            return jQuery('#' + frameId).get(0);			
    },
    createUploadForm: function(id, fileElementId, data)
	{
		//create form	
		var formId = 'jUploadForm' + id;
		var fileId = 'jUploadFile' + id;
		var form = jQuery('<form  action="" method="POST" name="' + formId + '" id="' + formId + '" enctype="multipart/form-data"></form>');	
		if(data)
		{
			for(var i in data)
			{
				jQuery('<input type="hidden" name="' + i + '" value="' + data[i] + '" />').appendTo(form);
			}			
		}		
		var oldElement = jQuery('#' + fileElementId);
		var newElement = jQuery(oldElement).clone();
		jQuery(oldElement).attr('id', fileId);
		jQuery(oldElement).before(newElement);
		jQuery(oldElement).appendTo(form);


		
		//set attributes
		jQuery(form).css('position', 'absolute');
		jQuery(form).css('top', '-1200px');
		jQuery(form).css('left', '-1200px');
		jQuery(form).appendTo('body');		
		return form;
    },

    ajaxFileUpload: function(s) {
        // TODO introduce global settings, allowing the client to modify them for all requests, not only timeout		
        s = jQuery.extend({}, jQuery.ajaxSettings, s);
        var id = new Date().getTime()        
		var form = jQuery.createUploadForm(id, s.fileElementId, (typeof(s.data)=='undefined'?false:s.data));
		var io = jQuery.createUploadIframe(id, s.secureuri);
		var frameId = 'jUploadFrame' + id;
		var formId = 'jUploadForm' + id;		
        // Watch for a new set of requests
        if ( s.global && ! jQuery.active++ )
		{
			jQuery.event.trigger( "ajaxStart" );
		}            
        var requestDone = false;
        // Create the request object
        var xml = {}   
        if ( s.global )
            jQuery.event.trigger("ajaxSend", [xml, s]);
        // Wait for a response to come back
        var uploadCallback = function(isTimeout)
		{			
			var io = document.getElementById(frameId);
            try 
			{				
				if(io.contentWindow)
				{
					 xml.responseText = io.contentWindow.document.body?io.contentWindow.document.body.innerHTML:null;
                	 xml.responseXML = io.contentWindow.document.XMLDocument?io.contentWindow.document.XMLDocument:io.contentWindow.document;
					 
				}else if(io.contentDocument)
				{
					 xml.responseText = io.contentDocument.document.body?io.contentDocument.document.body.innerHTML:null;
                	xml.responseXML = io.contentDocument.document.XMLDocument?io.contentDocument.document.XMLDocument:io.contentDocument.document;
				}						
            }catch(e)
			{
				jQuery.handleError(s, xml, null, e);
			}
            if ( xml || isTimeout == "timeout") 
			{				
                requestDone = true;
                var status;
                try {
                    status = isTimeout != "timeout" ? "success" : "error";
                    // Make sure that the request was successful or notmodified
                    if ( status != "error" )
					{
                        // process the data (runs the xml through httpData regardless of callback)
                        var data = jQuery.uploadHttpData( xml, s.dataType );    
                        // If a local callback was specified, fire it and pass it the data
                        if ( s.success )
                            s.success( data, status );
    
                        // Fire the global callback
                        if( s.global )
                            jQuery.event.trigger( "ajaxSuccess", [xml, s] );
                    } else
                        jQuery.handleError(s, xml, status);
                } catch(e) 
				{
                    status = "error";
                    jQuery.handleError(s, xml, status, e);
                }

                // The request was completed
                if( s.global )
                    jQuery.event.trigger( "ajaxComplete", [xml, s] );

                // Handle the global AJAX counter
                if ( s.global && ! --jQuery.active )
                    jQuery.event.trigger( "ajaxStop" );

                // Process result
                if ( s.complete )
                    s.complete(xml, status);

                jQuery(io).unbind()

                setTimeout(function()
									{	try 
										{
											jQuery(io).remove();
											jQuery(form).remove();	
											
										} catch(e) 
										{
											jQuery.handleError(s, xml, null, e);
										}									

									}, 100)

                xml = null

            }
        }
        // Timeout checker
        if ( s.timeout > 0 ) 
		{
            setTimeout(function(){
                // Check to see if the request is still happening
                if( !requestDone ) uploadCallback( "timeout" );
            }, s.timeout);
        }
        try 
		{

			var form = jQuery('#' + formId);
			jQuery(form).attr('action', s.url);
			jQuery(form).attr('method', 'POST');
			jQuery(form).attr('target', frameId);
            if(form.encoding)
			{
				jQuery(form).attr('encoding', 'multipart/form-data');      			
            }
            else
			{	
				jQuery(form).attr('enctype', 'multipart/form-data');			
            }			
            jQuery(form).submit();

        } catch(e) 
		{			
            jQuery.handleError(s, xml, null, e);
        }
		
		jQuery('#' + frameId).load(uploadCallback);
        return {abort: function () {}};	

    },

    uploadHttpData: function( r, type ) {
        var data = !type;
        data = type == "xml" || data ? r.responseXML : r.responseText;
        // If the type is "script", eval it in global context
        if ( type == "script" )
            jQuery.globalEval( data );
        // Get the JavaScript object, if JSON is used.
        if ( type == "json" )
        	eval("data = \" "+data+" \" ");
        // evaluate scripts within html
        if ( type == "html" )
            jQuery("<div>").html(data).evalScripts();

        //return data;
        
        return $.parseJSON($(data).text());
    },
    
    handleError: function( s, xhr, status, e ) {
    	// If a local callback was specified, fire it		
    	if ( s.error ) {			
    		s.error.call( s.context || s, xhr, status, e );		
    	}		
    	// Fire the global callback		
    	if ( s.global ) {			
    		(s.context ? jQuery(s.context) : jQuery.event).trigger( "ajaxError", [xhr, s, e] );		
    	}	
    }
})

