" Vim global plugin Psearch for parallel searching the pattern string 
" or regular expression in your current file.
" Last Change: 2013 Jun 1st
" Maintainer: Fengan Li <leo.pku.cs@gmail.com> 
" 			  Jingwen Deng <dejiwe1992@gmail.com>
" License: This file is placed in the public domain.

" Psearch is a function which can find your designated pattern string 
" parallel and locate the cursor at the position of the next or the 
" previous pattern string.
" @param arg1	pattern string
" @param arg2	find direction 
" 				'D' means find the next one
" 				'F' means find the previous one

function! Psearch(arg1, arg2)
	let firstarg=a:arg1
	let secondarg = a:arg2
python << pythonend
#!/usr/bin/env python
"""
A simple example of parallel computation using map-style processing.
"""
import vim
import pprocess
import time
import sys
#import random

# Array size and a limit on the number of processes.
searchPattern = vim.eval("a:arg1")
searchMode    = vim.eval("a:arg2")

totalLength = len(vim.current.buffer)
curIndex = vim.current.window.cursor[0]-1
N = 8
stepLength=1000000
limit = 10
minIndex = -1
# Work function.

def calculate(t):
#    "A supposedly time-consuming calculation on 't'."
    leftNum, rightNum, myBuffer = t
    #time.sleep(delay * random.random())
    if (searchMode == "D"):
	for i in range(leftNum, rightNum):
		line = myBuffer[i]
		findNum = line.find(searchPattern)
		if (findNum > -1):
			return (i+1, findNum)
    elif (searchMode == "F"):
	for i in range(-rightNum, -leftNum):
		line = myBuffer[-i]
		findNum = line.find(searchPattern)
		if (findNum > -1):
			return (-i+1, findNum)
# Main program.

if __name__ == "__main__":

    t = time.time()
    # Initialise an array.
    if (searchMode == "D"):
	curIndex = curIndex+1
	flagFind = -1
	while(curIndex < totalLength):
		sequence=[]
		flagEnd = -1
		for i in range(0, N):
			leftNum=curIndex+i*stepLength
			if (curIndex+(i+1)*stepLength < totalLength):
				rightNum = curIndex+(i+1)*stepLength
			else:
				rightNum = totalLength
				flagEnd = i
			sequence.append((leftNum, rightNum, vim.current.buffer))
			if (flagEnd != -1):
				break
		results = pprocess.pmap(calculate, sequence, limit=limit)
		if (flagEnd == -1):
			for i in range(0,N):
				if(results[i] != None):
					vim.current.window.cursor=results[i]
					print "Target Hit!"
				        print "Time taken:", time.time() - t
					flagFind = 1
					break
		else:
			for i in range(0, flagEnd+1):
				if(results[i] != None):
					vim.current.window.cursor=results[i]
					print "Target Hit!"
					print "Time taken:", time.time() - t
					flagFind = 1
                    			break
		if (flagFind == 1):
			break
		curIndex = curIndex + N * stepLength
	if (flagFind == -1):
		print "No Hit!"
		print "Time taken:", time.time() - t
    elif (searchMode == "F"):
	curIndex = curIndex - 1
	flagFind = -1
	while(curIndex > -1):
		sequence=[]
		flagEnd = -1
		for i in range(0, N):
			rightNum = curIndex-i*stepLength
			if ((curIndex - (i+1)*stepLength) > -1):
				leftNum = curIndex - (i+1)*stepLength
			else:
				leftNum = -1
				flagEnd = i
			sequence.append((leftNum, rightNum, vim.current.buffer))
			if (flagEnd != -1):
				break
		results = pprocess.pmap(calculate, sequence, limit = limit)
		if (flagEnd == -1):
			for i in range(0,N):
				if(results[i] != None):
					vim.current.window.cursor=results[i]
					print "Target Hit"
					print "Time taken:", time.time()-t
					flagFind = 1
					break
		else:
			for i in range(0, flagEnd+1):
                                if(results[i] != None):
                                        vim.current.window.cursor=results[i]
                                        print "Target Hit!"
                                        print "Time taken:", time.time() - t
                                        flagFind = 1
                                        break
		if (flagFind == 1):
			break
		curIndex = curIndex - N * stepLength
	if (flagFind == -1):
		print "No Hit!"
		print "Time taken:", time.time()-t

						

# vim: tabstop=4 expandtab shiftwidth=4
pythonend
endfunction


" PRsearch is a function which can find your designated regular expression
" parallel and locate the cursor at the position of the next or the 
" previous string which matches the regular expression. 
" @param arg1	regular expression
" @param arg2	find direction 
" 				'D' means find the next one
" 				'F' means find the previous one
"

function! PRsearch(arg1, arg2)
	let firstarg=a:arg1
	let secondarg = a:arg2
python << pythonend
#!/usr/bin/env python
"""
A simple example of parallel computation using map-style processing.
"""
import vim
import pprocess
import time
import sys
import re
#import random

# Array size and a limit on the number of processes.
searchPattern = vim.eval("a:arg1")
searchMode    = vim.eval("a:arg2")

totalLength = len(vim.current.buffer)
curIndex = vim.current.window.cursor[0]-1
N = 8
stepLength=1000000
limit = 10
minIndex = -1
# Work function.

def calculate(t):
#    "A supposedly time-consuming calculation on 't'."
    leftNum, rightNum, myBuffer = t
    #time.sleep(delay * random.random())
    if (searchMode == "D"):
	for i in range(leftNum, rightNum):
		line = myBuffer[i]
	   	m = re.search(searchPattern, line)
       		if (m != None):
			return (i+1, m.start())
    elif (searchMode == "F"):
	for i in range(-rightNum, -leftNum):
		line = myBuffer[-i]
		m = re.search(searchPattern, line)
		if (m != None):
			return (-i+1, m.start())
# Main program.

if __name__ == "__main__":

    t = time.time()
    # Initialise an array.
    if (searchMode == "D"):
	curIndex = curIndex+1
	flagFind = -1
	while(curIndex < totalLength):
		sequence=[]
		flagEnd = -1
		for i in range(0, N):
			leftNum=curIndex+i*stepLength
			if (curIndex+(i+1)*stepLength < totalLength):
				rightNum = curIndex+(i+1)*stepLength
			else:
				rightNum = totalLength
				flagEnd = i
			sequence.append((leftNum, rightNum, vim.current.buffer))
			if (flagEnd != -1):
				break
		results = pprocess.pmap(calculate, sequence, limit=limit)
		if (flagEnd == -1):
			for i in range(0,N):
				if(results[i] != None):
					vim.current.window.cursor=results[i]
					print "Target Hit!"
				        print "Time taken:", time.time() - t
					flagFind = 1
					break
		else:
			for i in range(0, flagEnd+1):
				if(results[i] != None):
					vim.current.window.cursor=results[i]
					print "Target Hit!"
					print "Time taken:", time.time() - t
					flagFind = 1
                    			break
		if (flagFind == 1):
			break
		curIndex = curIndex + N * stepLength
	if (flagFind == -1):
		print "No Hit!"
		print "Time taken:", time.time() - t
    elif (searchMode == "F"):
	curIndex = curIndex - 1
	flagFind = -1
	while(curIndex > -1):
		sequence=[]
		flagEnd = -1
		for i in range(0, N):
			rightNum = curIndex-i*stepLength
			if ((curIndex - (i+1)*stepLength) > -1):
				leftNum = curIndex - (i+1)*stepLength
			else:
				leftNum = -1
				flagEnd = i
			sequence.append((leftNum, rightNum, vim.current.buffer))
			if (flagEnd != -1):
				break
		results = pprocess.pmap(calculate, sequence, limit = limit)
		if (flagEnd == -1):
			for i in range(0,N):
				if(results[i] != None):
					vim.current.window.cursor=results[i]
					print "Target Hit"
					print "Time taken:", time.time()-t
					flagFind = 1
					break
		else:
			for i in range(0, flagEnd+1):
                                if(results[i] != None):
                                        vim.current.window.cursor=results[i]
                                        print "Target Hit!"
                                        print "Time taken:", time.time() - t
                                        flagFind = 1
                                        break
		if (flagFind == 1):
			break
		curIndex = curIndex - N * stepLength
	if (flagFind == -1):
		print "No Hit!"
		print "Time taken:", time.time()-t

						

# vim: tabstop=4 expandtab shiftwidth=4
pythonend
endfunction
