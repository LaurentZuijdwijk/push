sys = require('sys')
exec = require('child_process').exec
color = require('colors')
async = require('async')

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


execGitCommit = (cb)->
	puts = (error, stdout, stderr)=>
		if error then @cb(error, null)
		sys.puts(stdout) 
		cb('null', stdout);
	if options.m 
		cmd = "git commit -m '"+options.m+"'"
		exec(cmd, puts)	
		console.log(String(cmd).green.bold.inverse);
	else 
		console.log('Please enter a commit message'.red.bold.inverse);
		process.stdin.resume()
		process.stdin.setEncoding('utf8')
		process.stdin.on('data', (chunk) ->
			# cb(new Error('error'))
			if chunk is '\n' 
				process.stdin.pause()
				execGitCommit(cb)
			else
				options.m += chunk

		)
		
		

 
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
	async.apply(execGitCommit),
	async.apply(execGit,"git status"),
	async.apply(getRevision)
])
