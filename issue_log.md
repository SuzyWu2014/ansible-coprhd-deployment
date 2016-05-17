
# Kill the Proxy

+ Logs for later try...
  - set system-wide proxy (set env variables)
  - use redsocks, doesn't compatible with osu proxy server
  - set proxy to gradle -> failed at play:compile; still dependency module missing
  - set gradle to play configuration file -> doesn't work 
  - directly call "play deps" with proxy options -> failed with artifact not found
  - directly install deadbolt -> failed with module not found 
  - store deadbolt in local directory, and configure play to use local repo

+ Next step:
  - More play plugin configuration?
  - Gradle ivy configuration?
  - Dive more in play implementation?
  - Figure out how gradle, ivy and play work with each other?
