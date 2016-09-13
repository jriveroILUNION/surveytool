<%@page import="ilu.surveytool.language.Language"%>
<%@page import="ilu.surveytool.constants.Address"%>
<%@page import="ilu.surveytool.databasemanager.DataObject.Question"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.concurrent.TimeUnit"%>
<%@page import="java.util.Iterator"%>
<%@page import="ilu.surveytool.databasemanager.constants.DBConstants"%>
<%@page import="ilu.surveytool.databasemanager.ResponsesDB"%>
<%@page import="ilu.surveytool.constants.Attribute"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="ilu.surveytool.databasemanager.DataObject.Survey"%>
<%@page import="ilu.surveytool.databasemanager.DataObject.Page"%>
<%@page import="ilu.surveytool.databasemanager.DataObject.Section"%>
<%@page import="ilu.surveymanager.statistics.Statistics"%>
<%@page import="ilu.surveymanager.statistics.StatisticsQuestion"%>
<%@page import="ilu.surveymanager.handler.SurveysHandler"%>

<script type="text/javascript">
	surveyTree = <%= request.getAttribute(Attribute.s_JSON_PAGES) %>;
</script>
<!--<script language="JavaScript" src="http://www.geoplugin.net/javascript.gp" type="text/javascript"></script> Esto es para obtener la IP y la localizaci�n -->
<%
Survey survey = (Survey) request.getAttribute(Attribute.s_SURVEY_INFO);
SurveysHandler surveysHandler = new SurveysHandler();

Language lang = new Language(getServletContext().getRealPath("/")); 
String languageId = Language.getLanguageRequest(request);
lang.loadLanguage(languageId);
//System.out.println("String language default: "+survey.getDefaultLanguage());

String titlesurvey = "";
if(survey!=null && survey.getContents()!=null && survey.getContents().get(DBConstants.s_VALUE_CONTENTTYPE_NAME_TITLE)!=null && !survey.getContents().get(DBConstants.s_VALUE_CONTENTTYPE_NAME_TITLE).getText().equals("")){
	titlesurvey = survey.getContents().get(DBConstants.s_VALUE_CONTENTTYPE_NAME_TITLE).getText();
}

Statistics surveyStatistic = surveysHandler.createStatistics(survey.getSurveyId(), languageId, survey.getDefaultLanguage());
%>

<div class="container-fluid">




	  				<div class="title-content-no-underline">
	  					<h2 id="title-header-edit"><a href="InitialServlet"><%= lang.getContent("user_panel.title") %></a> > <a href="UserPanelHomeServlet?upoption=surveys"><%= lang.getContent("survey_manager.title") %></a> > <%= lang.getContent("survey.statistic.title") %></h2>
	  					<ul class="nav nav-tabs nav-tabs-right nav-tab-edit">						  	
						  	<li role="presentation" class="statistic-tab active" id="statistic-tab"><a href="#" aria-label="<%= lang.getContent("survey.edit.tab.go_statistics") %>" title="<%= lang.getContent("survey.edit.tab.go_statistics") %>" id="tab-display-statistics"><i class="fa fa-bar-chart fa-2x"></i></a></li>
						  	<li role="presentation" class="share-tab" id="share-tab"><a href="#" title="<%= lang.getContent("survey.edit.tab.go_edit") %>"><i class="fa fa-share-alt fa-2x"></i></a></li>
						  	<li role="presentation" class="edit-tab" id="edit-tab"><a href="SurveysServlet?surveyid=<%=survey.getSurveyId()%>" aria-label="<%= lang.getContent("survey.edit.tab.go_edit") %>" title="<%= lang.getContent("survey.edit.tab.go_edit") %>" id="tab-display-questions"><i class="fa fa-pencil-square-o fa-2x"></i></a></li>
						</ul>
	  				</div>
	  				
	  				<div class="content-box-tabs edit-content">
	  						
	  						<div class="edit-survey-frame survey-info">
		  						<div class="widthTitleSurveyCollapsed">
		  							<p class="survey-info-title" aria-label="<%= lang.getContent("survey.edit.info.aria_label.title") %>"> <%= titlesurvey %></p>
			  					</div>	
		  					</div>	
	  						
	  								
<div id="statistics">
	<div class="main-sidebar">
		<ul class="sidebar-menu">
        	<li class="treeview active" id="general-menu"><a href="#"><%= lang.getContent("statistics.menu.general")%></a></li>
        	<li class="treeview">
          		<span><%= lang.getContent("statistics.menu.questions")%></span>
          		
          		<select class="form-control" id="statistics-questions-menu">
          			<option value="question-0" selected><%= lang.getContent("statistics.menu.default")%></option>
          		<%
          		for(Section section : survey.getSections()){
					for(Page pag : section.getPages()){
						for(Question question : pag.getQuestions()){
							String title = "";
							if(question!=null &&  question.getContents()!=null && question.getContents().get(DBConstants.s_VALUE_CONTENTTYPE_NAME_TITLE)!=null){
								title = question.getContents().get(DBConstants.s_VALUE_CONTENTTYPE_NAME_TITLE).getText();
							}
							%>
							<option value="<%= "question-"+question.getQuestionId() %>"><%= title %></option>
							<%
							}
						}
					}
          		%>
				</select>
        	</li> 
      	</ul>
  	</div>
  	
  <div class="content-wrapper">
      <div class="content-statistics" id="general-info">
	      <div class="row">
	        <div class="col-md-4">
	          <div class="small-box bg-aqua">
	            <div class="inner">
	              <h3 aria-hidden="true"><%= surveyStatistic.getNumVisits()%></h3>
	              <p><%= lang.getContent("statistics.boxes.numStarted")%></p><span class="visuallyhidden">: <%= surveyStatistic.getNumVisits()%></span>
	            </div>
	          </div>
	        </div>
	        
	        <div class="col-md-4">
	          <div class="small-box bg-green">
	            <div class="inner">
	            	<h3 aria-hidden="true"><%=(int)(surveyStatistic.getNumCompleteMandatoryResponses()) %></h3>
	              <p><%= lang.getContent("statistics.boxes.numAnswers")%></p><span class="visuallyhidden">: <%=(int)(surveyStatistic.getNumCompleteMandatoryResponses()) %></span>
	            </div>
	          </div>
	        </div>
	         
	        <div class="col-md-4">
	          <div class="small-box bg-red">
	            <div class="inner">
	               <%
	            if(surveyStatistic.getNumVisits()>0){
	            	//System.out.println(surveyStatistic.getNumCompleteMandatoryResponses());
	            %>
	              <h3 aria-hidden="true"><%= (int)((surveyStatistic.getNumCompleteMandatoryResponses()*1.0/surveyStatistic.getNumVisits()*1.0)*100) %><sup>%</sup></h3>
	              <p><%= lang.getContent("statistics.boxes.bounceRateStarted")%></p><span class="visuallyhidden">: <%= (int)((surveyStatistic.getNumCompleteMandatoryResponses()*1.0/surveyStatistic.getNumVisits()*1.0)*100) %><sup>%</sup></span>
	            <%
	            } else{
	            %>
	              <h3 aria-hidden="true"> - <sup>%</sup></h3>
	              <p><%= lang.getContent("statistics.boxes.bounceRateStarted")%></p><span class="visuallyhidden">: 0%</span>
	            <%
	            }
	            %>
	              
	            </div>
	          </div>
	        </div>
	          
	      </div>
	      
	      <div class="row">
	      	<section class="col-md-6 connectedSortable ui-sortable">
	      		<div class="nav-tabs-custom no-block">
	            	<!-- Tabs within a box -->
	            	<p class="graph-title  no-block"><%= lang.getContent("statistics.boxes.numStarted")%></p>
	            	<span class="visuallyhidden">
					<%
							
							String[][] data = surveyStatistic.groupVisitsByDay(10);
							for(int i = 0; i<data.length;i++){
								//System.out.println(i);
								%>
		        		    	<%=data[i][0]%>, <%= lang.getContent("statistics.boxes.numStarted")%>: <%=data[i][1]%><%if(i<data.length-1){%><%="\n"%><%}%>
		        		    	<%
							}
							%>
					</span>
	            	<div class="tab-content no-padding  no-block">
						<div class="chart tab-pane active" id="visits-chart">
		              		<canvas id="visits" width="550" height="250" style="width: 550px; height: 250px;"></canvas>
							<script>
							
								var labels = [];
								var data = [];
							<%
							
							for(int i = 0; i<data.length;i++){
								//System.out.println(i);
								%>
		        		    	labels.push("<%=data[i][0]%>");
		        		    	data.push(<%=data[i][1]%>);
		        		    	<%
							}
							%>
								  var data = {
								    labels: labels,
								    datasets: [
								      {
								        fillColor: "rgba(0,0,0,0)",
								        strokeColor: "#007593",
								        pointColor: "#007593",
								        pointStrokeColor: "#fff",
								        pointHighlightFill: "#fff",
								        pointHighlightStroke: "#007593",
								        data: data
								      }
								    ]
								  };
								
								  var ctx = document.getElementById("visits").getContext("2d");
								
								  var myChart = new Chart(ctx).Line(data, {
									  tooltipCaretSize: 0
									  });
								  
							</script>
						</div>	            	
	            	
		             
		              </div>
	            	</div>
	      	</section>
	      	<section class="col-md-6 connectedSortable ui-sortable">
	      		<div class="nav-tabs-custom no-block">
	            	<!-- Tabs within a box -->
	            	<p class="graph-title no-block"><%= lang.getContent("statistics.boxes.numAnswers")%></p>
	            	<span class="visuallyhidden">
					<%
					data = surveyStatistic.groupCompletedByDay(10);
							for(int i = 0; i<data.length;i++){
								//System.out.println(i);
								%>
		        		    	<%=data[i][0]%>, <%= lang.getContent("statistics.boxes.numAnswers")%>: <%=data[i][1]%><%if(i<data.length-1){%><%="\n"%><%}%>
		        		    	<%
							}
							%>
					</span>
	            	<div class="tab-content no-padding no-block">
						<div class="chart tab-pane active" id="responses-chart">
		              		<canvas id="responses" width="550" height="250" style="width: 550px; height: 250px;"></canvas>
							<script>
							
								var labels = [];
								var dataMandatory = [];
							<%
							
							
							for(int i = 0; i<data.length;i++){
								//System.out.println(i);
								%>
		        		    	labels.push("<%=data[i][0]%>");
		        		    	dataMandatory.push(<%=data[i][1]%>);
		        		    	<%
							}
							%>
							
							
							
							
							 var data = {
									    labels: labels,
									    datasets: [
									      {
									        label: "<%= lang.getContent("statistics.boxes.numAnswersMand")%>",
									        showInLegend: true,
									        fillColor: "rgba(0,0,0,0)",
									        strokeColor: "#00884b",
									        pointColor: "#00884b",
									        pointStrokeColor: "#fff",
									        pointHighlightFill: "#fff",
									        pointHighlightStroke: "#00884b",
									        data: dataMandatory
									      }
									    ]
									  };

							 // Get the context of the canvas element we want to select
									var ctx = document.getElementById("responses").getContext("2d");
								  
								  //don't forget to pass options in when creating new Chart
								  var lineChart = new Chart(ctx).Line(data, {
									  tooltipCaretSize: 0
								  });
									  
									  
							</script>
						</div>	            	
	            	
		             
		              </div>
	          		</div>
	      		</section>
	    	</div>
      	</div>
      
 		<% 
 		String token = "/";
 		for(Section section : survey.getSections()){
					for(Page pag : section.getPages()){
						for(Question question : pag.getQuestions()){
							request.setAttribute(Attribute.s_QUESTION, question);
							request.setAttribute(Attribute.s_SURVEY_STATISTIC, surveyStatistic.getStatisticsByQuestion(question.getQuestionId()));
							//System.out.println(question.getQuestionId()+", "+question.getQuestionType()+", token + question.getStatisticsPage() -->"+token + question.getStatisticsPage());
	  							%>
								<div class="content-statistics hidden" id="single-question-<%= question.getQuestionId() %>">
	  								<jsp:include page="<%= token + question.getStatisticsPage() %>">
										<jsp:param name="index" value="<%= question.getQuestionId() %>" />
									</jsp:include>
    							</div>
								<%
						}
					}
          		}
          		%>     
      	
    
	</div>
</div>
	</div>
	  			</div>
<%
lang.close();
%>
	  			
	  			<jsp:include page="../frames/fNewQuestion.jsp" />
	  			
	  			<jsp:include page="../frames/fImportFile.jsp" />
	  			
	  			<jsp:include page="../frames/fUpdateFile.jsp" />
	  			
	  			<jsp:include page="../frames/fDeleteElement.jsp" />
	  			  			