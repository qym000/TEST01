	<%--Copyright (c) MINGYOUTECH Co. Ltd.--%>
	
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"> 
	<meta http-equiv="pragma" content="no-cache"> 
    <meta http-equiv="cache-control" content="no-cache"> 
    <meta http-equiv="expires" content="0">
    
    <script type="text/javascript" src="${ctx}/mybi/common/script/lib/jquery.js"></script>
    
	<link rel="stylesheet" type="text/css" href="${ctx}/mybi/common/script/lib/easyui/themes/${apptheme}/easyui.css">
	<link rel="stylesheet" type="text/css" href="${ctx}/mybi/common/script/lib/easyui/themes/icon.css">
	<script type="text/javascript" src="${ctx}/mybi/common/script/lib/easyui/jquery.easyui.min.js"></script>
	<!-- i18n zh_CN -->	
	<s:if test='#session.i18nDefault=="zh"'>
		<script type="text/javascript" src="${ctx}/mybi/common/script/lib/easyui/locale/easyui-lang-zh_CN.js"></script>
	</s:if>
	<s:elseif test='#session.i18nDefault=="en"'>
	<!-- i18n en -->
		<script type="text/javascript" src="${ctx}/mybi/common/script/lib/easyui/locale/easyui-lang-en.js"></script>
	</s:elseif>
	<script type="text/javascript" src="${ctx}/mybi/common/script/easyui.datagrid.extend.js"></script>
	<script type="text/javascript" src="${ctx}/mybi/common/script/easyui.panel.extend.js"></script>
	
	
	<script type="text/javascript" src="${ctx}/mybi/common/script/my.jslib.js" ></script>
	
	<link rel="stylesheet" type="text/css" href="${ctx}/mybi/pim/theme/icon.css">
	
	<link rel="stylesheet" type="text/css" href="${ctx}/mybi/common/theme/${apptheme}/form.css">
	<link rel="stylesheet" type="text/css" href="${ctx}/mybi/common/script/lib/formvalidator/themes/Default/style/style.css">
	<script type="text/javascript" src="${ctx}/mybi/common/script/lib/formvalidator/formValidator-4.1.3.min.js"></script>
	<script type="text/javascript" src="${ctx}/mybi/common/script/lib/formvalidator/formValidatorRegex.js"></script>
	<script type="text/javascript" src="${ctx}/mybi/common/script/lib/formvalidator/themes/Default/js/theme.js"></script>	
	
	<script type="text/javascript">
	$(document).ready(function(){
	    $.ajaxSetup({ 
		    error: function(XMLHttpRequest, textStatus, errorThrown){
					if(XMLHttpRequest.status==403){
						alert('error');
						return false;
					}
			},  
	        complete:function(XMLHttpRequest,textStatus){   
	       	    var sessionstatus=XMLHttpRequest.getResponseHeader("sessionstatus");
	            if(sessionstatus=='async_session_timeout'){   
	                window.location.href = 'sessionerror.jsp';  
	       	    }   
	        }   
	    }); 
	    
	 	//action auth filter
	    actionAuthFilter('${session.sysActionJSONArrayWithAuth}');
	});
	</script>
	