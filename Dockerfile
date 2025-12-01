# Giai đoạn 1: Xây dựng ứng dụng
FROM node:20-alpine AS build

# Đặt thư mục làm việc trong container
WORKDIR /app

# Sao chép package.json và package-lock.json (để tận dụng cache Docker)
COPY package*.json ./

# Cài đặt dependencies
RUN npm install

# Sao chép mã nguồn còn lại
COPY . .

# Xây dựng ứng dụng Vue.js (sẽ tạo thư mục 'dist' với các tệp tĩnh)
# Sử dụng biến môi trường (ví dụ: VITE_API_URL) nếu cần
RUN npm run build

# ---
# Giai đoạn 2: Image Nginx nhẹ để phục vụ tệp tĩnh
FROM nginx:stable-alpine AS final

# Sao chép cấu hình Nginx tùy chỉnh (tùy chọn)
# Nếu không có cấu hình tùy chỉnh, Nginx mặc định sẽ hoạt động
# COPY nginx.conf /etc/nginx/nginx.conf

# Xóa cấu hình Nginx mặc định
RUN rm /etc/nginx/conf.d/default.conf

# Tạo cấu hình Nginx để phục vụ ứng dụng Vue.js (dành cho chế độ History)
COPY --from=build /app/nginx-default.conf /etc/nginx/conf.d/default.conf

# Sao chép các tệp tĩnh đã được xây dựng từ giai đoạn 'build' vào thư mục phục vụ của Nginx
# Thay 'dist' bằng thư mục đầu ra thực tế của bạn nếu khác
COPY --from=build /app/dist /usr/share/nginx/html

# Mở cổng 80 (cổng HTTP mặc định của Nginx)
EXPOSE 80

# Lệnh mặc định của Nginx (để chạy Nginx)
CMD ["nginx", "-g", "daemon off;"]