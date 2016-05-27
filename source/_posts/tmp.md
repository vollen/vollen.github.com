

# base
## UI
## Net
## Cache
## Log
## Utils

# modules
## UI
## Net
## Cache


## Net
### Service
### Api
#### C2S
#### S2C

# CREW
## SERVICE
## API
## USECASE
## HANDLE -> SUBSCRIBER

API api = Service.retrofit.create(api.class)
api.call.subscribe(handle)


### Handle<T api>
+ send(T c2s)
+ onNetError()
+ onCodeError()
+ onSuccess(T s2c)

### NetUtil

### login



