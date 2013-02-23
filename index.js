var sys = require('sys'),
	exec = require('child_process').exec,
	color = require('colors'),
	async = require('async');

var options = {};

processArgs = function(cb){
	process.argv.forEach(function (val, index, array) {
  		switch(val){
  			case '-m':
  				options.m = array[index+1]
  			break;
  		}
	});
	cb(null)
}




//wait till testing is done
// do a git status
// do a pull
// do a add .
// do a commit
// wait for message

async.series([
	//async.apply(exectest)},
	async.apply(processArgs),
	async.apply(execGit,"git pull"),
	async.apply(execGit,"git status"),

	async.apply(execGit,"git add ."),
	async.apply(execGitCommit),
	async.apply(execGit,"git status"),
	async.apply(getRevision)
]);

function execTest(cb){
	exec('testacular run', puts)
}

function execGitCommit(cb){
	function puts(error, stdout, stderr) {
		if(error) cb(error, null)
		sys.puts(stdout) 
		cb(null, stdout);
	}
	if(options.m){
		var cmd = "git commit -m '"+options.m+"'"
		exec(cmd, puts)	
		console.log(String(cmd).green.bold.inverse);
	}
	else cb(null)
}
 
function execGit(cmd, cb){
function puts(error, stdout, stderr) {
	if(error) cb(error, null)
	sys.puts(stdout) 
	cb(null, stdout);
}
	console.log(cmd.green.bold.inverse)
	exec(cmd, puts)	
}
function getRevision(cb){
	var cmd = 'git rev-list HEAD --count';

	exec(cmd, function(error, stdout, stderr){
		console.log('revision: '.green.inverse.bold + ' r'.green.inverse.bold + stdout.green.inverse.bold);
		cb(null)
	})	

}