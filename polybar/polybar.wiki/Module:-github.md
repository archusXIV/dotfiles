This module shows the unread notification count using the GitHub API.

**NOTE:** This module requires the project to be built with cURL support.

You will need to [generate a GitHub personal access token](https://github.com/settings/tokens/new?scopes=notifications&description=Notifier+for+Polybar) where at least `notifications` is in the scope.

### Basic settings
```ini
[module/github]
type = internal/github

; Accessing an access token stored in file
token = ${file:/path/to/file/containing/github/access.token}

; Accessing an access token stored in an environment variable
token = ${env:GITHUB_ACCESS_TOKEN}

; The github user for the token
; Effectively required; otherwise the module uses a deprecated method of fetching
; notifications, which has stopped working
user = github_user

; Whether empty notifications should be displayed or not
empty-notifications = false

; Number of seconds in between requests
interval = 10

; Github API URL
; Default: https://api.github.com/
api-url = https://hub.example.org/api/v3/
```

### Additional formatting
```ini
; Available tags:
;   <label> (default)
format = <label>

; Available tokens:
;   %notifications% (default)
; Default: Notifications: %notifications%
label = %notifications%

; Used when GitHub can't be reached
; Available tags:
;   <label-offline> (default)
format-offline = <label-offline>

; Available tokens:
;   None
; Default: Offline
label-offline = Offline
```
