<%@page import="org.json.JSONArray"%>
<%@page import="model.Conexao"%>
<%@page import="org.json.JSONObject"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=0.5">
<title>Socios</title>

<script type="text/javascript" src="js/jquery.js"></script>
<script type="text/javascript" src="js/bootstrap.min.js"></script>
<script src="https://kit.fontawesome.com/5000ee8fc6.js" crossorigin="anonymous"></script>

<link rel="stylesheet" href="css/bootstrap.min.css">
<link rel="stylesheet" type="text/css" href="css/style.css">
<link href="https://fonts.googleapis.com/css?family=Fjalla+One&display=swap" rel="stylesheet">

<script src="https://js.api.here.com/v3/3.1/mapsjs-core.js" type="text/javascript" charset="utf-8"></script>
<script src="https://js.api.here.com/v3/3.1/mapsjs-service.js" type="text/javascript" charset="utf-8"></script>
<script charset="UTF-8" src="js/script.js"></script>
</head>
<body>
	<%
	HttpSession hs = request.getSession();
	if(hs.getAttribute("cnpj") != null){
		Conexao conection = new Conexao();
		JSONObject obj = new JSONObject();
		obj.put("cnpj", hs.getAttribute("cnpj"));
		String result = conection.conexao(obj, 2,"svMensagem");
		JSONObject obVerify = new JSONObject(result);
	%>
	<div class="pos-f-t ">
		<div class="collapse" id="navbarToggleExternalContent">
			<div class="bg-dark p-2">
				<ul class="navbar-nav">
					<li class="nav-item pt-lg-0 pt-3"><a
						class="nav-link text-white mr-3" href="login.jsp">Login</a></li>
				</ul>
			</div>
		</div>

		<nav class="navbar navbar-dark">
			<button id="hamb">
				<span class="hamburguer"></span>
				<%
					if (obVerify.getBoolean("verify")) {
						out.println("<span class=\"new\"></span>");
					}
				%>
			</button>
			<div id="mySidebar" class="sidebar">
				<button class="close-side">&times;</button>
				<a href="home.jsp"> <i class="fas fa-home"></i>
					FEED
				</a> <a href="perfil.jsp"> <i class="fas fa-user"></i> PERFIL
				</a> <a href="socios.jsp" class="active"> <i class="fas fa-user-friends"></i>
					SOCIOS
				</a> <a href="solicitacoes.jsp"> <i class="fas fa-address-book"></i>
					SOLICITA��ES
				</a> <a href="mensagem.jsp"> <i class="fas fa-comments"></i>
					MENSAGENS <% if (obVerify.getBoolean("verify")) { out.println("<span class=\"new\"></span>"); }%>
				</a> <a href="agenda.jsp"> <i class="fas fa-calendar-alt"></i>
					AGENDA
				</a> <a href="meusprodutos.jsp"> <i class="fas fa-box"></i> MEUS
					PRODUTOS
				</a> <a href="pedidos.jsp"> <i class="fas fa-truck"></i> PEDIDOS
				</a>
				<form method="POST" action="servlet">
					<input type="hidden" name="action" value="3">
					<button>
						<i class="fas fa-sign-out-alt"></i> SAIR
					</button>
				</form>
			</div>
			<div class="logo jusify-content-center">
				<a class="navbar-brand" href="index.jsp">
					<h1>
						<img class="nav-item" src="icons/logo.png" height="45px">eRelation
					</h1>
				</a>
			</div>
			<div style="color: white; font-size: 42px; margin-right: 20px">
				<%
					conection = new Conexao();
					result = conection.conexao(obj, 18, "svEmpresa");
					obVerify = new JSONObject(result);
					if (obVerify.getBoolean("verify")) {
						out.println("<span class=\"new\"></span>");
					}
				%>

				<a href="caixaentrada.jsp" style="color: white;"><i
					class="fas fa-envelope"></i></a>
			</div>
		</nav>
	</div>
	
	
	<%
	JSONObject obj2 = new JSONObject();
	obj2.put("cnpj_origem",  hs.getAttribute("cnpj"));
	conection = new Conexao();

	result = conection.conexao(obj2, 11, "svEmpresa");
	if(!result.isEmpty() && !result.equals("[]")){
		JSONArray arr = new JSONArray(result);
	%>
	<div id="socios" class="col-lg-8 col-10 container-fluid">
        <div class="separator">
            <h5>S�CIOS</h5>
        </div>
		<div id="solicitacoes">
		<%
			for (int i = 0; i < arr.length(); i++) {
				JSONObject ob = arr.getJSONObject(i);
				if(ob.getString("cnpj_origem").equals(hs.getAttribute("cnpj"))){
					System.out.println(ob.toString());
					JSONObject objt = new JSONObject();
					objt.put("cnpj", ob.getString("cnpj_dest"));
					result = conection.conexao(objt, 3, "svEmpresa");
					JSONObject objs = new JSONObject(result);
					%>
					<div class="card">
			            <div class="img col-12 col-lg-5" style="background-image: url('http://<%=conection.getIp()%>:<%=conection.getPort()%>/WebServlet/svEmpresa?cnpj=<%=objs.getString("cnpj")%>');">
			            </div>
						<div class="card-body">
							<p><%=objs.getString("empresa") %></p>
							<div class="group">
								<a class="btn btn-primary" href="perfilempresa.jsp?cnpj=<%=objs.getString("cnpj")%>">Vizualizar perfil</a>
								<form method="POST" action="servlet">
									<input name='action' value='7' type='hidden'>
									<input name='cnpjDest' value='<%=ob.getString("cnpj_origem") %>' type='hidden'>
									<button class="btn btn-danger d-center">Deixar de ser s�cio</button>
								</form>
							</div>
						</div>
					</div>
					<% 
					
				} else {
					System.out.println(ob.toString());
					JSONObject objt = new JSONObject();
					objt.put("cnpj", ob.getString("cnpj_origem"));
					result = conection.conexao(objt, 3, "svEmpresa");

					JSONObject objs = new JSONObject(result);
					%>
					<div class="card">
			            <div class="img col-12 col-lg-5" style="background-image: url('http://<%=conection.getIp()%>:<%=conection.getPort()%>/WebServlet/svEmpresa?cnpj=<%=objs.getString("cnpj")%>');">
			            </div>
						<div class="card-body">
							<p><%=objs.getString("empresa") %></p>
							<div class="group">
								<a class="btn btn-primary" href="perfilempresa.jsp?cnpj=<%=objs.getString("cnpj")%>">Vizualizar perfil</a>
								<form method="POST" action="servlet">
									<input name='action' value='7' type='hidden'>
									<input name='cnpjDest' value='<%=ob.getString("cnpj_origem") %>' type='hidden'>
									<button class="btn btn-danger d-center">Deixar de ser s�cio</button>
								</form>
							</div>
						</div>
					</div>
			<%
				}
			}
			%>
		</div>
	</div>
	<% } else { %>
	<div class="empty">
		<img src="img/empty2.png" class="col-6">
		<div class="empty-body">
			<h1>Ops!</h1>
			<p>
				Parece que sua empresa n�o possui s�cios.
			</p>
			<span class="obs">
				Obs.: Voc� pode enviar um convite para uma empresa ou aceitar um convite de outra. Voc� pode ver novos convites na pagina de solicita��es.
			</span>
			<a href="solicitacoes.jsp" class="empty-button">Ver solicita��es</a>
			<a href="home.jsp" class="empty-button">Explorar</a>
		</div>
	</div>
	<%} 
	} else {
		response.sendRedirect("index.jsp?e=1002");
	}%>
</body>
</html>