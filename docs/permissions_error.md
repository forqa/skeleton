## Setting up Ruby Version Manager for deciding permissions problems

1. Install rvm (\curl -sSL https://get.rvm.io | bash -s stable).
2. Check that rvm is available from terminal (which rvm). If not, set it in your .bash_profile.
3. Install latest ruby via rvm (rvm install ruby).
4. Set default ruby from rvm, instead of system ruby (rvm --default <version>).
5. Make sure, that you use latest ruby from rvm (ruby -v).
6. Reinstall skeleton without sudo (gem install skeleton-ui).