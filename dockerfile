# First Stage: Build the Jekyll Site
FROM ruby:3.1 AS jekyll-build

# Install dependencies
RUN apt-get update && \
    apt-get install -y git build-essential && \
    gem update --system && \
    gem install jekyll bundler && \
    rm -rf /var/lib/apt/lists/*

# Set the working directory to /app
WORKDIR /app

# Clone the Jekyll theme repository (You can replace this URL with any Jekyll repo)
RUN git clone https://github.com/cotes2020/jekyll-theme-chirpy.git .

# Install Jekyll dependencies and build the site
RUN bundle install && \
    jekyll build -d /site

# Second Stage: Serve with Apache
FROM httpd:latest

# Copy the built site from the previous stage to Apache's web directory
COPY --from=jekyll-build /site/ /usr/local/apache2/htdocs/

# Expose port 80 for the web server
EXPOSE 80

# Start Apache in the foreground
CMD ["httpd-foreground"]
