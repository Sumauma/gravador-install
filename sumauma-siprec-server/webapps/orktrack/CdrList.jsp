<%--
  Created by IntelliJ IDEA.
  User: borracha
  Date: 4/23/22
  Time: 9:58 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <!--  jQuery -->
    <script type="text/javascript" src="https://code.jquery.com/jquery-1.11.3.min.js"></script>
    <!-- Isolated Version of Bootstrap, not needed if your site already uses Bootstrap -->
    <link rel="stylesheet" href="https://formden.com/static/cdn/bootstrap-iso.css" />

    <!-- Bootstrap Date-Picker Plugin -->
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.4.1/js/bootstrap-datepicker.min.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.4.1/css/bootstrap-datepicker3.css"/>

    <script>
        $(document).ready(function(){
            var date_input1=$('input[name="startdate"]'); //our date input has the name "date"
            var date_input2=$('input[name="enddate"]'); //our date input has the name "date"
            var container=$('.bootstrap-iso form').length>0 ? $('.bootstrap-iso form').parent() : "body";
            var options={
                format: 'dd/mm/yyyy',
                container: container,
                todayHighlight: true,
                autoclose: true,
            };
            date_input1.datepicker(options);
            date_input2.datepicker(options);
        })
    </script>
    <title>Recordings Application</title>
    <style>
        .parentCell{
            position: relative;
        }
        .borrachatooltip{
            display: none;
            position: absolute;
            z-index: 100;
            border: 1px;
            background-color: white;
            border: 1px solid green;
            padding: 3px;
            color: green;
            top: 20px;
            left: 20px;
        }
        .parentCell:hover span.borrachatooltip{
            display:block;
        }
    </style>
</head>
<body>
    <div class="bootstrap-iso">
        <h2>SIPREC Recorder 1.1 Sumaúma Telecom</h2>
        <h2>
            <div class="container-fluid">
                <div class="row">
                    <div class="col-md-6 col-sm-6 col-xs-12">
                        <div>
                            <a href="/orktrack/cdrs">All Cdrs</a>
                        </div>
                        <div style="display: flex">
                            <form method="get" action="/orktrack/cdrs">
                                <div class="form-group">
                                    <label class="control-label" for="callid">XSR-Call-ID</label>
                                    <input type="text" id="callid" name="callid" class="form-control" placeholder="Search for XSR-Call-ID">
                                </div>
                                <div class="form-group"> <!-- Submit button -->
                                    <button type="submit" name="save" class="btn btn-primary">Search</button>
                                    <input type="text" name="type" value="callid" hidden>
                                </div>
                            </form>
                            <form method="get" action="/orktrack/cdrs">
                                <div class="form-group">
                                    <label class="control-label" for="ucid">XSR-UCID</label>
                                    <input type="text" id="ucid" name="ucid" class="form-control" placeholder="Search for XSR-UCID">
                                </div>
                                <div class="form-group"> <!-- Submit button -->
                                    <button type="submit" name="save" class="btn btn-primary">Search</button>
                                    <input type="text" name="type" value="ucid" hidden>
                                </div>
                            </form>
                            <form method="get" action="/orktrack/cdrs">
                                <div style="display: flex">
                                    <div class="form-group">
                                        <label class="control-label" for="from">From</label>
                                        <input type="text" id="from" name="from" class="form-control" placeholder="Search for From">
                                    </div>
                                    <div class="form-group">
                                        <label class="control-label" for="to">To</label>
                                        <input type="text" id="to" name="to" class="form-control" placeholder="Search for To">
                                    </div>
                                    <div class="form-group"> <!-- Date input -->
                                        <label class="control-label" for="startdate">Data Inicial</label>
                                        <input class="form-control" id="startdate" name="startdate" placeholder="DD/MM/YYYY" type="text"/>
                                    </div>
                                    <div class="form-group"> <!-- Date input -->
                                        <label class="control-label" for="enddate">Data Final</label>
                                        <input class="form-control" id="enddate" name="enddate" placeholder="DD/MM/YYYY" type="text"/>
                                    </div>
                                    <div class="form-group">
                                        <button type="submit" name="save" class="btn btn-primary">Search</button>
                                        <input type="text" name="type" value="fromto" hidden>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </h2>
        <div align="center">
            <table border="1" cellpadding="5" cellspacing="5">
                <caption><h2>List of Cdrs</h2></caption>
                <tr>
                    <th>ID</th>
                    <th>ISR Call Id</th>
                    <th>ISR UCID</th>
                    <th>Call Id</th>
                    <th>From</th>
                    <th>To</th>
                    <th>Session Id</th>
                    <th>Associate Time</th>
                    <th>Created Date</th>
                    <th>Updated Date</th>
                    <th>XML</th>
                    <th>Filename</th>
                    <th>Actions</th>
                </tr>
                <c:forEach var="cdr" items="${listCdr}">
                    <tr>
                        <td><c:out value="${cdr.id}" /></td>
                        <td><c:out value="${cdr.isrCallId}" /></td>
                        <td><c:out value="${cdr.isrUcid}" /></td>
                        <td><c:out value="${cdr.callId}" /></td>
                        <td><c:out value="${cdr.from}" /></td>
                        <td><c:out value="${cdr.to}" /></td>
                        <td><c:out value="${cdr.sessionId}" /></td>
                        <td><c:out value="${cdr.associateTime}" /></td>
                        <td><c:out value="${cdr.created}" /></td>
                        <td><c:out value="${cdr.updated}" /></td>
                        <td class="parentCell">hover to see XML
                            <span class="borrachatooltip"><c:out value="${cdr.xml}" /></span>
                        </td>
                        <td><c:out value="${cdr.filename}" /></td>
                        <td>
                            <a href="/orktrack/download?id=<c:out value='${cdr.id}' />">Download WAV</a>
                        </td>
                    </tr>
                </c:forEach>
            </table>
            <c:if test="${currentPage != 1}">
                <td><a href="/orktrack/cdrs?page=${currentPage - 1}">Previous</a></td>
            </c:if>

            <table border="1" cellpadding="5" cellspacing="5">
                <tr>
                    <c:forEach begin="1" end="${noOfPages}" var="i">
                        <c:choose>
                            <c:when test="${currentPage eq i}">
                                <td>${i}</td>
                            </c:when>
                            <c:otherwise>
                                <td><a href="/orktrack/cdrs?page=${i}">${i}</a></td>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>
                </tr>
            </table>
            <c:if test="${currentPage lt noOfPages}">
                <td><a href="/orktrack/cdrs?page=${currentPage + 1}">Next</a></td>
            </c:if>
        </div>
    </div>
</body>
</html>
