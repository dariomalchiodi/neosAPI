(* ::Package:: *)

(* : Title : neosAPI *)
(* : Context : neosAPI` *)
(* : 
    Author : Dario Malchiodi *)
(* : Summary : NEOS - API client *)
(* : 
    Package Version : 1.0 *)
(* : Mathematica Version : 5.1 *)
(* : 
    Keywords : NEOS *)

BeginPackage["neosAPI`"]

neosHelp::usage = "neosHelp[] returns a general help message";\

neosEmailHelp::usage = "neosEmailHelp[] returns a general help message for email users";\

neosWelcome::usage = "neosWelcome[] returns a welcome message";\

neosVersion::usage = "neosVersion[] returns a string containing the  version number of the NEOS server";\

neosPing::usage = "neosPing[] returns the string \"NeosServer is alive\" when the NEOS server is running";\

neosPrintQueue::usage = "neosPrintQueue[] returns a string containing the current NEOS jobs";\

neosGetSolverTemplate::usage = "neosGetSolverTemplate[category, solverName, inputMethod] returns a template for a given solver";\

neosListAllSolvers::usage = "neosListAllSolvers[] returns a string listing all solvers available on NEOS, each shown in the format category:solver:inputMethod";\

neosListCategories::usage = "neosListCategories[] returns a dictionary containing all categories available on NEOS";\

neosListSolversInCategory::usage = "neosListSolversInCategory[category] returns a string listing all solvers for a given category, each shown in the format solver:input";\

neosSubmitJob::usage = "neosSubmitJob[request] submits tho the NEOS server a given catetory encoded in standard XML-RPC format, returning a list {jobNumber, password} or a string containing the description of an occurred error}";\

neosGetJobStatus::usage = "neosGetJobStatus[jobNumber, password] returns either \"Done\", \"Running\", \"Waiting\", \"Unknown Job\", or \"Bad Password\" according to the given job status";\

neosGetFinalResults::usage = "neosGetFinalResults[jonNumner, password] rerturns a string containing the given job's output. If the job is still running, the function will hang until it completes.";\

neosGetJobInfo::usage = "neosGetJobInfo[jobNumber, password] returns a string describing a 4-ple (category, solverName, input, status) describing the specified job status";\

neosKillJob::usage = "neosKillJob[jobNumber, password] kills the specified job.";\

neosGetFinalResultsNonBlocking::usage = "neosGetFinalResultsNonBlocking[jobNumber, password] retrieves the results of a job, returning an empty string if the latter is still running. In this way the function always returns without hanging.";\

neosGetIntermediateResults::usage = "neosGetIntermediateResults[jobNumber, password, offset] retrieves intermediate results of a job, starting at character offset up to the last received data. The function hangs until another packet of output is sent or the job is finished.";\

neosGetIntermediateResultsNonBlocking::usage = "neosGetIntermediateResultsNonBlocking[jobNumber, password, offset] retrieves intermediate results of a job, starting at character offset up to the last received data. The function returns an empty string if the job is still running.";\

neosSolveJob::usage = "neosSolveJon[request] submits tho the NEOS server a given catetory encoded in standard XML-RPC format and returns the corresponding job output. The function will hang until the job completes.";\

Begin["`Private`"]



Needs["xmlRPC`"];
xmlRPCServer = "neos-1.chtc.wisc.edu";
xmlRPCPort = 3332;
xmlRPCInit[xmlRPCServer, xmlRPCPort];

neosHelp[] := xmlRPC["help", {}]

neosEmailHelp[] := xmlRPC["emailHelp", {}]

neosWelcome[] := xmlRPC["welcome", {}]

neosVersion[] := xmlRPC["version", {}]

neosPing[] := xmlRPC["ping", {}]

neosPrintQueue[] := xmlRPC["printQueue", {}]

neosGetSolverTemplate[category_, solvername_, inputMethod_] := 
  xmlRPC["getSolverTemplate", {{"string", category}, {"string", 
        solvername}, {"string", inputMethod}}]

neosListAllSolvers[] := xmlRPC["listAllSolvers", {}]

neosListCategories[] := xmlRPC["listCategories", {}]

neosListSolversInCategory[category_] := 
  xmlRPC["listSolversInCategory", {{"string", category}}]

neosSubmitJob[request_] := 
  xmlRPC["submitJob", {{"string", request}, {"string", "user=''"}, {"string", 
        "interface=''"}, {"string", "id=0"}}]

neosGetJobStatus[jobNum_, jobPwd_] := 
  xmlRPC["getJobStatus", {{"int", jobNum}, {"string", jobPwd}}]

neosGetFinalResults[jobNum_, jobPwd_] := 
  xmlRPC["getFinalResults", {{"int", jobNum}, {"string", jobPwd}}]

neosGetJobInfo[jobNum_, jobPwd_] := 
  xmlRPC["getJobInfo", {{"int", jobNum}, {"string", jobPwd}}]

neosKillJob[jobNum_, jobPwd_] := 
  xmlRPC["killJob", {{"int", jobNum}, {"string", jobPwd}, {"string", 
        "killmsg=''"}}]

neosGetFinalResultsNonBlocking[jobNum_, jobPwd_] := 
  xmlRPC["getFinalResultsNonBlocking", {{"int", jobNum}, {"string", jobPwd}}]

neosGetIntermediateResults[jobNum_, jobPwd_, offset_] := 
  xmlRPC["getIntermediateResults", {{"int", jobNum}, {"string", jobPwd}, {"int",
         ToString[offset]}}]

neosGetIntermediateResultsNonBlocking[jobNum_, jobPwd_, offset_] := 
  xmlRPC["getIntermediateResultsNonBlocking", {{"int", jobNum}, {"string", 
        jobPwd}, {"int", ToString[offset]}}]

neosSolveJob[request_] :=Block[{jobNum, jobPwd},
	{jobNum, jobPwd} = neosSubmitJob[request];
	While[neosGetJobStatus[jobNum, jobPwd] != "Done",
		Pause[10];
	];
	neosGetFinalResults[jobNum, jobPwd]
]

End[]

EndPackage[]
