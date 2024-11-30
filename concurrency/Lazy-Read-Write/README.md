In cases like the one given below, if 2 requests arrive at same time, the thread which runs first is responsible for the result
```
3 3 3
3 2 3
1 1 DELETE 0
2 1 READ 0
STOP
```

In cases like this where a read/write request is performed after a delete request the read/write request is declined only after it has been taken up by LAZY
```
3 3 3
3 2 3
1 1 READ 0
3 1 DELETE 11
4 1 WRITE 12
5 1 READ 13
STOP
```

Invalid requests like in this test case are ignored and the rest are run
```
2 4 6
3 2 5
4 1 WRITE 3
0 1 WRITE 3  -> Usernumber 0 invalid
2 2 WRITE 1
2 0 WRITE 1  -> Filenumber 0 invalid
5 2 READ 4
5 2 HELLO 4  -> HELLO operation is invalid
1 1 READ 0   -> Requestnumber 0 is valid
3 2 DELETE 2
STOP
```

In this case the requet is cancelled because of user limit on request and not because of deleting a file which is being written
```
3 3 3
3 1 3
1 1 READ 0
3 1 DELETE 1
4 1 WRITE 2
5 1 READ 3
STOP
```

In this case the delete request gets delayed and not cancelled
```
3 3 3
3 2 3
1 1 READ 0
3 1 DELETE 1
4 1 WRITE 2
5 1 READ 3
STOP
```

Since requests need not be in non-decreasing order of time, we first collect all valid requests, then sort all these requests based on the time and then start the execution

Q22 and Q23. If an operation example WRITE completes at 6s then another WRITE on the same file which arrived at 4s, then the next WRITE should start at 6s or 7s? Essentially, if an operation completes at ts then can another operation start at ts on the same file?
[KM] Yes. The only requirement is that LAZY waits 1 second from the time of the request's arrival before it can take that request up. Assuming that another request arrived on the same file before t seconds, LAZY should indeed be able to pick it up as soon as some other request on that same file is done processing
```
4 3 5
6 1 6
1 1 READ 0
10 6 DELETE 0
4 1 DELETE 1
15 1 READ 3
STOP
```
