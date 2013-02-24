sys = require('sys')
exec = require('child_process').exec
color = require('colors')
async = require('async')
cli = require('cli')

options = {
	m:''
}

processArgs = (cb)->
	process.argv.forEach( (val, index, array)=> 
		if val is '-m' then options.m = array[index+1]
		)
	cb(null)




# //wait till testing is done
# // do a git status
# // do a pull
# // do a add .
# // do a commit
# // wait for message


execTest = (cb)->
	exec('testacular run', puts)



execGit = (cmd, cb) ->
	puts = (error, stdout, stderr)->
		if(error) then cb(error, null)
		sys.puts(stdout) 
		cb(null, stdout);

	console.log(cmd.green.bold.inverse)
	exec(cmd, puts)	

getRevision = (cb) ->
	cmd = 'git rev-list HEAD --count'
	exec(cmd, (error, stdout, stderr) ->
		console.log('revision: '.green.inverse.bold + ' r'.green.inverse.bold + stdout.green.inverse.bold);
	)
	cb(null)


async.series([
	# async.apply(execTest),
	async.apply(processArgs),
	async.apply(execGit,"git pull"),

	async.apply(execGit,"git add ."),
	async.apply(execGit,"git status"),
	async.apply(require('./commit')),
	async.apply(execGit,"git status"),
	async.apply(getRevision)
])
