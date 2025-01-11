import { defineConfig } from 'vite';
import vue from '@vitejs/plugin-vue';
import path from 'path';
import eslintPlugin from 'vite-plugin-eslint';

// Proxy target
const target = 'http://localhost:3000';

export default defineConfig({
    base: '/', // 기본값
    plugins: [vue(), eslintPlugin()],
    build: {
        // outputDir 설정을 build.outDir로 대체
        outDir: path.resolve(__dirname, '../server/public'),
    },
    server: {
        proxy: {
            '/api': {
                target,
                changeOrigin: true,
                ws: false,
            },
        },
    },
    resolve: {
        alias: {
            // @ 를 src 폴더에 매핑
            '@': path.resolve(__dirname, 'src'),
        },
        extensions: ['.js', '.vue', '.json'],
    },
    css: {
        preprocessorOptions: {
            scss: {
                additionalData: `@import "@/assets/scss/variables.scss";`,
            },
        },
    },
});
