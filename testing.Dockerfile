# 1
FROM swift:5.8-jammy

# 2
WORKDIR /app
# 3
COPY . ./
# 4
CMD ["swift", "test"]
