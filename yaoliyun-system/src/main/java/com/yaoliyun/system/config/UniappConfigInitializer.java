package com.yaoliyun.system.config;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.stereotype.Component;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

/**
 * UniApp配置初始化器
 * 在应用启动时验证UniApp项目路径配置
 * 
 * @author yaoliyun
 * @date 2024-01-15
 */
@Component
public class UniappConfigInitializer implements ApplicationRunner {
    
    private static final Logger log = LoggerFactory.getLogger(UniappConfigInitializer.class);
    
    @Value("${uniapp.project.path:../yaoliyun-uniapp}")
    private String uniappProjectPath;
    
    @Override
    public void run(ApplicationArguments args) throws Exception {
        validateUniappConfig();
    }
    
    /**
     * 验证UniApp配置
     */
    private void validateUniappConfig() {
        try {
            log.info("开始验证UniApp项目配置...");
            log.info("配置的UniApp项目路径: {}", uniappProjectPath);
            
            // 获取绝对路径
            Path projectPath = Paths.get(uniappProjectPath).toAbsolutePath();
            log.info("解析后的绝对路径: {}", projectPath);
            
            // 检查项目目录是否存在
            if (!Files.exists(projectPath)) {
                log.error("❌ UniApp项目目录不存在: {}", projectPath);
                log.error("请检查配置文件中的 uniapp.project.path 设置");
                return;
            }
            
            // 检查pages.json文件是否存在
            Path pagesJsonPath = projectPath.resolve("pages.json");
            if (!Files.exists(pagesJsonPath)) {
                log.error("❌ pages.json文件不存在: {}", pagesJsonPath);
                log.error("请确保指定的目录是有效的UniApp项目");
                return;
            }
            
            // 检查pages目录是否存在
            Path pagesDir = projectPath.resolve("pages");
            if (!Files.exists(pagesDir)) {
                log.warn("⚠️ pages目录不存在，将在需要时自动创建: {}", pagesDir);
            }
            
            log.info("✅ UniApp项目配置验证成功！");
            log.info("项目目录: {}", projectPath);
            log.info("pages.json: {}", pagesJsonPath);
            log.info("pages目录: {}", pagesDir);
            
        } catch (Exception e) {
            log.error("❌ UniApp项目配置验证失败: {}", e.getMessage(), e);
        }
    }
} 