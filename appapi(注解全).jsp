<%@page contentType="application/json;charset=utf-8"%>
<%@page import="java.util.*"%>
<%@page import="java.sql.*"%>
<%@page import="com.rsc.rs.pub.util.*"%>
<%@page import="com.rsc.rs.pub.util.functions.*"%>
<%@page import="com.rsc.rs.pub.dbUtil.*"%>
<%@page import="com.rsc.rs.sys.util.*"%>
<%@page import="com.rsc.mainframe.control.web.*"%>
<%@page import="java.io.*"%>
<%@page import="java.net.*"%>
<%

SelRs rsSr  = new SelRs("");
String json="[]";
request.setCharacterEncoding("utf-8");
response.setCharacterEncoding("utf-8");

String flag=(String)request.getParameter("flag");
flag=URLDecoder.decode(flag,"utf-8");
System.out.println("flag is:"+flag);
if(flag.equals("insert"))//添加
{
	json=insert(rsSr, request);
}

else if(flag.equals("delete")){
	json=delete(rsSr, request);
}

else if(flag.equals("update")){
	json=update(rsSr, request);
}

else if(flag.equals("query")){
	json=query(rsSr, request);
}

else if(flag.equals("detail")){
	json=detail(rsSr, request);
}

else if(flag.equals("select")){
	json=superQuery(rsSr, request);
}
out.write(json);
%>

<%!
    //数据集转换为JSON
	public String ResultSet2Json(ResultSet rs) throws SQLException
	{
		String json="[]";
		String temp="";
		while(rs!=null&&rs.next())
		{
			ResultSetMetaData rsmd = rs.getMetaData();
			temp+="{";
			for(int i=1;i<=rsmd.getColumnCount();i++){//遍历表头
				temp+="\""+rsmd.getColumnName(i)+"\":\""+rs.getString(i)+"\",";
			}
			temp=temp.substring(0,temp.length() - 1);
			temp+="},";
		}
		if(temp.length()>0)
		{
			temp=temp.substring(0,temp.length() - 1);
			json="["+temp+"]";
		}
		return json;
	}
    //======================superquery=================================
	public String superQuery( SelRs rsSr, HttpServletRequest request ) throws Exception{
		ResultSet rs=null;
	    RequestUtil ru = new RequestUtil(request);//对URL的查询进行解析
		String json="";
		String sql=ru.getParameter("sql");
		System.out.println("sql = "+sql);
		rs = rsSr.getRs(sql);//结果集
		json=ResultSet2Json(rs);
		return json;
	}
    //======================query（select all where operator——code和页面传回数据一致。company_code没管）=================================
	public String query( SelRs rsSr, HttpServletRequest request ) throws Exception{
		ResultSet rs=null;
	    RequestUtil ru = new RequestUtil(request);
		String json="";
	    String queryCondition = " 1=1 ";  //查询条件初始化也可以为空
	    if(!(ru.getParameter("operatorCode").equals("")))//操作人员编号非空
	    {
	    queryCondition=queryCondition+" and operator_code='"+ru.getParameter("operatorCode")+"'";
	    }
	    System.out.println("qqqqqqqqqqqszquery = "+queryCondition);
		String strSql="select uuid,equipment_code,box_code,work_procedure,start_time,end_time,status,operator_name  from EQU_ACTIVITY  where " + queryCondition;
		System.out.println("qqqqqqqqqqqszquery = "+strSql);
		rs = rsSr.getRs(strSql);//结果集
		json=ResultSet2Json(rs);
		return json;
	}
	//=================detail（select all where 设备号和罐箱号从前台取数）================================
	public String detail( SelRs rsSr, HttpServletRequest request ) throws Exception{
		ResultSet rs=null;
	    RequestUtil ru = new RequestUtil(request);
		String json="";
        //通过前台获取的设备号查看罐箱号
		rs = rsSr.getRs("select box_code from EQU_ACTIVITY where equipment_code='"+request.getParameter("equipmentCode")+"'");
		while(rs!=null&&rs.next())
			{
		  String  BOXCODE = rs.getString("box_code");
		 System.out.println("qqqqqqqqqqqszdetail = "+BOXCODE);

		}

	    String queryCondition = " 1=1 ";
	    //设备号和罐箱号都非空
	    if(!(ru.getParameter("equipmentCode").equals(""))&&!(ru.getParameter("boxCode").equals("")))
	    {
	    queryCondition=queryCondition+" and equipment_code='"+ru.getParameter("equipmentCode")+"'" + " and box_code='"+ru.getParameter("boxCode")+"'";
	    }
	    System.out.println("qqqqqqqqqqqszdetail = "+queryCondition);
		String strSql="select equipment_code,box_code,work_procedure,start_time,end_time,operator_name,status,operator_code,uuid,rowid  from EQU_ACTIVITY  where " + queryCondition;
	    System.out.println("qqqqqqqqqqqszdetail = "+strSql);
		rs = rsSr.getRs(strSql);
		json=ResultSet2Json(rs);
		return json;
	}
	//==============================insert==============================
	public String insert( SelRs rsSr, HttpServletRequest request ) throws Exception
	{
	    request.setCharacterEncoding("UTF-8");
		RequestUtil ru = new RequestUtil(request);//对URL的查询进行解析
	    String msgCode="";
		String msg="";
		String json="";
	    String insertsql="";
		// String name =java.net.URLEncoder.encode("测试","UTF-8");
		// System.out.println("name1 ="+name);
		// name = java.net.URLDecoder.decode("%E9%82%B1%E5%8F%8C%E6%AD%A3","UTF-8");
		// System.out.println("name2 ="+name);
		// System.out.println("operatorName1 ="+ru.getParameter("operatorName"));
		String operatorName = request.getParameter("operatorName");
	    //System.out.println("0000000000000000000000000 ="+operatorName);
		//operatorName = new String(operatorName.getBytes("iso-8859-1"),"UTF-8");
		//System.out.println("1111111111111111111111111 ="+operatorName);
		//String operatorname = new String(ru.getParameter("operatorName").getBytes("iso-8859-1"),"UTF-8");
		//System.out.println("2222222222222222222222222 ="+operatorName);
		//operatorName = operatorName.replaceAll("%(?![0-9a-fA-F]{2})","%25");
		// String operatorName1 = URLDecoder.decode(operatorName,"UTF-8");
		// String operatorName2 = URLDecoder.decode(operatorName1,"UTF-8");
		// System.out.println("operatorName2 ="+operatorName2);
		// System.out.println("operatorName3 ="+URLDecoder.decode(operatorName1,"UTF-8"));

		// String name3 = URLEncoder.encode(operatorName,"UTF-8");
		// System.out.println("name3"+name3);
		// String name4 = URLDecoder.decode(name3,"UTF-8");
		// System.out.println("name4"+name4);
        //获取查询出来的数字
	    int recNuml=rsSr.getRecordNum("select count(1) from EQU_ACTIVITY where equipment_code='"+ ru.getParameter("equipmentCode") +"'	and box_code='"+ ru.getParameter("boxCode") +"'",10);
		if(recNuml<1)//即UUID不存在
	    {
			String uuid=UUID.randomUUID().toString();
			uuid=uuid.substring(0,8)+uuid.substring(9,13)+uuid.substring(14,18)+uuid.substring(19,23)+uuid.substring(24);
			String companyCode = "07";
	    	insertsql = "insert into EQU_ACTIVITY (uuid,company_code,equipment_code,box_code,work_procedure,start_time,status,operator_code,operator_name) values('"
						+ uuid + "','"
						+ companyCode + "','"
						+ ru.getParameter("equipmentCode") + "','"
						+ ru.getParameter("boxCode") + "','"
						+ ru.getParameter("workProcedure") + "','"
						+ ru.getParameter("startTime") + "','"
						+ ru.getParameter("status") + "','"
						+ ru.getParameter("operatorCode") + "','"
						+ operatorName+ "')" ;
						//+ ru.getParameter("operatorName") + "')" ;
	    	System.out.println("qqqqqqqqqqqqqqqqqszinsert = "+insertsql);
			if (!rsSr.update(insertsql))
			{
				msgCode="0";
				msg="新增失败";
			}else
			{
				msgCode="1";
				msg="新增成功";
			}
		}
	    else//UUID存在
	    {
		    System.out.println("qqqqqqqqqqqqqqqqqszinsert22222 = ");
			msgCode="2";
			msg="该记录已存在，请核实！";
	    }
		json="[{\"msgCode\":\""+msgCode+"\",\"msg\":\""+msg+"\"}]";
		return json;
	}
	//====================delete(通过UUID来删除)========================================
	public String delete(SelRs rsSr, HttpServletRequest request) throws Exception
	{
		RequestUtil ru = new RequestUtil(request);
		String msgCode="";
		String msg="";
		String json="";
		String sql = "DELETE EQU_ACTIVITY   WHERE uuid='" + ru.getParameter("data_uuid") + "'";
		System.out.println("qqqqqqqqqqqszdelete = "+sql);

		if (!rsSr.update(sql)){
			msgCode="0";
			msg="删除失败";
		}else{
			msgCode="1";
			msg="删除成功";
		}
		json="[{\"msgCode\":\""+msgCode+"\",\"msg\":\""+msg+"\"}]";
		return json;
	}
	//=============================update(仅更新设备号和罐箱号)==================================
	public String update(SelRs rsSr, HttpServletRequest request) throws Exception//仍需修改,判断修改数据是否为空
	{
		RequestUtil ru = new RequestUtil(request);
		String msgCode="";
		String msg="";
		String json="";
		String sql = "UPDATE EQU_ACTIVITY SET equipment_code='" + ru.getParameter("data_equipment_code") + "' , box_code = '"
		                  + ru.getParameter("data_box_code") + "' WHERE uuid='" + ru.getParameter("data_uuid") + "'";
		System.out.println("qqqqqqqqqqqszupdate = "+sql);
		if (!rsSr.update(sql)){
			msgCode="0";
			msg="保存失败";
		}else{
			msgCode="1";
			msg="保存成功";
		}
		json="[{\"msgCode\":\""+msgCode+"\",\"msg\":\""+msg+"\"}]";
		return json;
	}
%>