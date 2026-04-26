package com.yaoliyun.system.service.impl;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.PrintWriter;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

import com.alibaba.fastjson2.JSON;
import com.alibaba.fastjson2.JSONArray;
import com.alibaba.fastjson2.JSONObject;
import com.yaoliyun.common.utils.SecurityUtils;
import com.yaoliyun.common.utils.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import com.yaoliyun.system.mapper.SysUniappPageMapper;
import com.yaoliyun.system.domain.SysUniappPage;
import com.yaoliyun.system.service.ISysUniappPageService;

/**
 * UniApp页面管理Service业务层处理
 * 
 * @author yaoliyun
 * @date 2024-01-15
 */
@Service
public class SysUniappPageServiceImpl implements ISysUniappPageService 
{
    private static final Logger log = LoggerFactory.getLogger(SysUniappPageServiceImpl.class);

    @Autowired
    private SysUniappPageMapper sysUniappPageMapper;

    @Value("${uniapp.project.path:../yaoliyun-uniapp}")
    private String uniappProjectPath;

    // 页面路径验证正则表达式
    private static final Pattern PAGE_PATH_PATTERN = Pattern.compile("^[a-zA-Z0-9_/-]+$");

    // 危险路径关键词
    private static final String[] DANGEROUS_KEYWORDS = {"../", "..", "\\", ":", "system", "root", "admin", "config"};

    /**
     * 查询UniApp页面管理
     * 
     * @param pageId UniApp页面管理主键
     * @return UniApp页面管理
     */
    @Override
    public SysUniappPage selectSysUniappPageByPageId(Long pageId)
    {
        return sysUniappPageMapper.selectSysUniappPageByPageId(pageId);
    }

    /**
     * 查询UniApp页面管理列表
     * 
     * @param sysUniappPage UniApp页面管理
     * @return UniApp页面管理
     */
    @Override
    public List<SysUniappPage> selectSysUniappPageList(SysUniappPage sysUniappPage)
    {
        return sysUniappPageMapper.selectSysUniappPageList(sysUniappPage);
    }

    /**
     * 新增UniApp页面管理
     * 
     * @param sysUniappPage UniApp页面管理
     * @return 结果
     */
    @Override
    public int insertSysUniappPage(SysUniappPage sysUniappPage)
    {
        sysUniappPage.setCreateBy(SecurityUtils.getUsername());
        sysUniappPage.setCreateTime(new Date());
        return sysUniappPageMapper.insertSysUniappPage(sysUniappPage);
    }

    /**
     * 修改UniApp页面管理
     * 
     * @param sysUniappPage UniApp页面管理
     * @return 结果
     */
    @Override
    public int updateSysUniappPage(SysUniappPage sysUniappPage)
    {
        sysUniappPage.setUpdateBy(SecurityUtils.getUsername());
        sysUniappPage.setUpdateTime(new Date());
        return sysUniappPageMapper.updateSysUniappPage(sysUniappPage);
    }

    /**
     * 批量删除UniApp页面管理
     * 
     * @param pageIds 需要删除的UniApp页面管理主键
     * @return 结果
     */
    @Override
    public int deleteSysUniappPageByPageIds(Long[] pageIds)
    {
        return sysUniappPageMapper.deleteSysUniappPageByPageIds(pageIds);
    }

    /**
     * 删除UniApp页面管理信息
     * 
     * @param pageId UniApp页面管理主键
     * @return 结果
     */
    @Override
    public int deleteSysUniappPageByPageId(Long pageId)
    {
        return sysUniappPageMapper.deleteSysUniappPageByPageId(pageId);
    }

    /**
     * 创建页面文件和目录
     * 
     * @param pageInfo 页面信息 (JSON格式)
     * @return 结果
     */
    @Override
    public boolean createPageFile(String pageInfo)
    {
        try {
            JSONObject pageJson = JSON.parseObject(pageInfo);
            String pagePath = pageJson.getString("pagePath");
            String pageTitle = pageJson.getString("pageTitle");
            String navigationStyle = pageJson.getString("navigationStyle");
            
            // 验证输入参数
            if (StringUtils.isEmpty(pagePath) || StringUtils.isEmpty(pageTitle)) {
                log.error("页面路径或标题不能为空");
                return false;
            }
            
            // 验证路径安全性
            if (!validatePagePath(pagePath)) {
                log.error("页面路径格式不正确或包含危险字符: {}", pagePath);
                return false;
            }

            // 检查页面是否已存在
            if (checkPagePathExists(pagePath)) {
                log.error("页面路径已存在: {}", pagePath);
                return false;
            }

            // 解析路径 - 确保路径以pages/开头
            String fullPath = pagePath;
            if (!pagePath.startsWith("pages/")) {
                fullPath = "pages/" + pagePath;
            }
            Path targetPath = Paths.get(uniappProjectPath, fullPath + ".vue");
            
            // 检查UniApp项目路径是否存在
            Path projectPath = Paths.get(uniappProjectPath);
            if (!Files.exists(projectPath)) {
                log.error("UniApp项目路径不存在: {}", uniappProjectPath);
                return false;
            }
            
            // 创建目录
            Files.createDirectories(targetPath.getParent());
            
            // 生成页面内容
            String pageContent = generatePageTemplate(pagePath, pageTitle, navigationStyle);
            
            // 写入文件
            try (FileWriter writer = new FileWriter(targetPath.toFile())) {
                writer.write(pageContent);
            }
            
            // 保存到数据库
            SysUniappPage page = new SysUniappPage();
            page.setPagePath(fullPath);
            page.setPageTitle(pageTitle);
            page.setNavigationStyle(StringUtils.isNotEmpty(navigationStyle) ? navigationStyle : "default");
            page.setStatus("0");
            page.setIsTabbar("0");
            page.setDescription("自动生成的页面");
            int insertResult = insertSysUniappPage(page);
            if (insertResult == 0) {
                log.error("保存页面信息到数据库失败: {}", fullPath);
                // 删除已创建的文件
                Files.deleteIfExists(targetPath);
                return false;
            }
            
            // 更新pages.json
            boolean updateResult = updatePagesJson();
            if (!updateResult) {
                log.error("创建页面后更新pages.json失败: {}", fullPath);
                // 回滚：删除文件和数据库记录
                Files.deleteIfExists(targetPath);
                sysUniappPageMapper.deleteSysUniappPageByPath(fullPath);
                return false;
            }
            
            log.info("页面创建成功: {}，文件路径: {}", fullPath, targetPath);
            return true;
            
        } catch (Exception e) {
            log.error("创建页面失败: {}", e.getMessage(), e);
            return false;
        }
    }

    /**
     * 删除页面文件和目录
     * 
     * @param pagePath 页面路径
     * @return 结果
     */
    @Override
    public boolean deletePageFile(String pagePath)
    {
        try {
            // 验证路径安全性
            if (!validatePagePath(pagePath)) {
                log.error("页面路径格式不正确: {}", pagePath);
                return false;
            }

            // 确保路径以pages/开头
            String fullPath = pagePath;
            if (!pagePath.startsWith("pages/")) {
                fullPath = "pages/" + pagePath;
            }
            
            Path targetPath = Paths.get(uniappProjectPath, fullPath + ".vue");
            boolean fileDeleted = false;
            
            // 删除文件
            if (Files.exists(targetPath)) {
                Files.delete(targetPath);
                fileDeleted = true;
                log.info("删除页面文件: {}", targetPath);
            } else {
                log.warn("页面文件不存在: {}", targetPath);
            }
            
            // 尝试删除空目录
            Path parentDir = targetPath.getParent();

            if (Files.exists(parentDir) && Files.list(parentDir).count() == 0) {
                Files.delete(parentDir);

                log.info("删除空目录: {}", parentDir);
            }
            
            // 从数据库删除（使用完整路径）
            int deleteResult = sysUniappPageMapper.deleteSysUniappPageByPath(fullPath);
            if (deleteResult == 0) {
                log.warn("数据库中未找到页面记录: {}", pagePath);
            }
            
            // 更新pages.json
            boolean updateResult = updatePagesJson();
            if (!updateResult) {
                log.error("删除页面后更新pages.json失败: {}", pagePath);
                return false;
            }
            
            log.info("页面删除成功: {}，文件删除: {}，数据库删除: {}", pagePath, fileDeleted, deleteResult > 0);
            return true;
            
        } catch (Exception e) {
            log.error("删除页面失败: {}", e.getMessage(), e);
            return false;
        }
    }

    /**
     * 更新pages.json配置
     * 
     * @return 结果
     */
    @Override
    public boolean updatePagesJson()
    {
        try {
            // 检查UniApp项目路径是否存在
            Path projectPath = Paths.get(uniappProjectPath);
            if (!Files.exists(projectPath)) {
                log.error("UniApp项目路径不存在: {}", uniappProjectPath);
                return false;
            }
            
            Path pagesJsonPath = Paths.get(uniappProjectPath, "pages.json");
            if (!Files.exists(pagesJsonPath)) {
                log.error("pages.json文件不存在: {}", pagesJsonPath);
                return false;
            }
            
            // 备份当前文件
            if (!backupPagesJson()) {
                log.warn("备份pages.json失败，继续执行更新操作");
            }
            
            byte[] bytes = Files.readAllBytes(pagesJsonPath);
            String content = new String(bytes, StandardCharsets.UTF_8);
            JSONObject pagesJson = JSON.parseObject(content);
            
            // 获取数据库中的页面列表
            List<SysUniappPage> pageList = selectSysUniappPageList(new SysUniappPage());
            
            // 过滤启用的页面并按优先级排序
            List<SysUniappPage> enabledPages = pageList.stream()
                .filter(page -> "0".equals(page.getStatus()))
                .sorted((p1, p2) -> {
                    // 定义页面优先级顺序
                    String[] priorityOrder = {
                        "pages/index/index",     // 首页
                        "pages/login/login",     // 登录页
                        "pages/user/index"       // 用户页
                    };
                    
                    int p1Index = -1, p2Index = -1;
                    for (int i = 0; i < priorityOrder.length; i++) {
                        if (priorityOrder[i].equals(p1.getPagePath())) p1Index = i;
                        if (priorityOrder[i].equals(p2.getPagePath())) p2Index = i;
                    }
                    
                    // 优先级页面排在前面
                    if (p1Index != -1 && p2Index != -1) return Integer.compare(p1Index, p2Index);
                    if (p1Index != -1) return -1;
                    if (p2Index != -1) return 1;
                    
                    // 其他页面按路径排序
                    return p1.getPagePath().compareTo(p2.getPagePath());
                })
                .collect(Collectors.toList());
            
            // 重新构建pages数组
            JSONArray pages = new JSONArray();
            for (SysUniappPage page : enabledPages) {
                JSONObject pageObj = new JSONObject();
                pageObj.put("path", page.getPagePath());
                
                JSONObject style = new JSONObject();
                style.put("navigationBarTitleText", page.getPageTitle());
                if (StringUtils.isNotEmpty(page.getNavigationStyle()) && !"default".equals(page.getNavigationStyle())) {
                    style.put("navigationStyle", page.getNavigationStyle());
                }
                pageObj.put("style", style);
                
                pages.add(pageObj);
            }
            
            pagesJson.put("pages", pages);
            
            // 更新tabBar配置
            updateTabBarConfig(pagesJson, enabledPages);
            
            // 写回文件
            try (FileWriter writer = new FileWriter(pagesJsonPath.toFile())) {
                writer.write(JSON.toJSONString(pagesJson, com.alibaba.fastjson2.JSONWriter.Feature.PrettyFormat));
            }
            
            log.info("pages.json更新成功，共更新{}个页面", pages.size());
            return true;
            
        } catch (Exception e) {
            log.error("更新pages.json失败: {}", e.getMessage(), e);
            return false;
        }
    }

    /**
     * 创建备份目录
     *
     * @param subDirectory 子目录名称
     * @return 备份目录路径
     */
    private Path createBackupDirectory(String subDirectory) throws IOException {
        Path projectPath = Paths.get(uniappProjectPath).toAbsolutePath();
        Path backupBaseDir = projectPath.resolve("backups");
        Path backupDir = subDirectory != null ? backupBaseDir.resolve(subDirectory) : backupBaseDir;

        if (!Files.exists(backupDir)) {
            Files.createDirectories(backupDir);
            log.info("创建备份目录: {}", backupDir);
        }

        return backupDir;
    }

    /**
     * 备份pages.json文件
     * 
     * @return 结果
     */
    @Override
    public boolean backupPagesJson()
    {
        try {
            Path pagesJsonPath = Paths.get(uniappProjectPath, "pages.json");
            if (!Files.exists(pagesJsonPath)) {
                return false;
            }

            // 创建备份目录
            Path backupDir = createBackupDirectory("pages.json");
            
            String timestamp = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
            Path backupPath = backupDir.resolve("pages.json." + timestamp + ".backup");
            
            Files.copy(pagesJsonPath, backupPath, StandardCopyOption.REPLACE_EXISTING);
            log.info("pages.json备份成功: {}", backupPath);
            return true;
            
        } catch (Exception e) {
            log.error("备份pages.json失败: {}", e.getMessage(), e);
            return false;
        }
    }

    /**
     * 同步pages.json中的页面到数据库
     * 
     * @return 结果
     */
    @Override
    public boolean syncPagesFromJson()
    {
        try {
            Path pagesJsonPath = Paths.get(uniappProjectPath, "pages.json");
            byte[] bytes = Files.readAllBytes(pagesJsonPath);
            String content = new String(bytes, StandardCharsets.UTF_8);
            JSONObject pagesJson = JSON.parseObject(content);
            
            JSONArray pages = pagesJson.getJSONArray("pages");
            for (int i = 0; i < pages.size(); i++) {
                JSONObject page = pages.getJSONObject(i);
                String path = page.getString("path");
                JSONObject style = page.getJSONObject("style");
                
                // 检查数据库中是否已存在
                SysUniappPage existingPage = sysUniappPageMapper.selectSysUniappPageByPath(path);
                if (existingPage == null) {
                    // 创建新记录
                    SysUniappPage newPage = new SysUniappPage();
                    newPage.setPagePath(path);
                    newPage.setPageTitle(style != null ? style.getString("navigationBarTitleText") : "未命名页面");
                    newPage.setNavigationStyle(style != null ? style.getString("navigationStyle") : "default");
                    newPage.setStatus("0");
                    newPage.setIsTabbar("0");
                    newPage.setDescription("从pages.json同步");
                    insertSysUniappPage(newPage);
                }
            }
            
            log.info("从pages.json同步页面成功");
            return true;
            
        } catch (Exception e) {
            log.error("同步pages.json失败: {}", e.getMessage(), e);
            return false;
        }
    }

    /**
     * 检查页面路径是否存在
     * 
     * @param pagePath 页面路径
     * @return 结果
     */
    @Override
    public boolean checkPagePathExists(String pagePath)
    {
        // 确保路径以pages/开头
        String fullPath = pagePath;
        if (!pagePath.startsWith("pages/")) {
            fullPath = "pages/" + pagePath;
        }
        
        // 检查文件是否存在
        Path filePath = Paths.get(uniappProjectPath, fullPath + ".vue");
        if (Files.exists(filePath)) {
            return true;
        }
        
        // 检查数据库中是否存在
        SysUniappPage existingPage = sysUniappPageMapper.selectSysUniappPageByPath(fullPath);
        return existingPage != null;
    }

    /**
     * 验证页面路径格式
     * 
     * @param pagePath 页面路径
     * @return 结果
     */
    @Override
    public boolean validatePagePath(String pagePath)
    {
        if (StringUtils.isEmpty(pagePath)) {
            return false;
        }
        
        // 检查是否包含危险字符
        for (String keyword : DANGEROUS_KEYWORDS) {
            if (pagePath.contains(keyword)) {
                return false;
            }
        }
        
        // 检查路径格式
        if (!PAGE_PATH_PATTERN.matcher(pagePath).matches()) {
            return false;
        }
        
        // 路径长度限制
        if (pagePath.length() > 100) {
            return false;
        }
        
        return true;
    }

    /**
     * 生成页面模板
     * 
     * @param pagePath 页面路径
     * @param pageTitle 页面标题
     * @param navigationStyle 导航栏样式
     * @return 页面内容
     */
    private String generatePageTemplate(String pagePath, String pageTitle, String navigationStyle)
    {
        StringBuilder template = new StringBuilder();
        template.append("<template>\n");
        template.append("  <view class=\"container\">\n");
        template.append("    <view class=\"page-header\">\n");
        template.append("      <text class=\"page-title\">").append(pageTitle).append("</text>\n");
        template.append("    </view>\n");
        template.append("    \n");
        template.append("    <view class=\"page-content\">\n");
        template.append("      <text class=\"welcome-text\">欢迎来到").append(pageTitle).append("页面</text>\n");
        template.append("      <text class=\"page-info\">页面路径: ").append(pagePath).append("</text>\n");
        template.append("      <text class=\"created-time\">创建时间: ").append(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date())).append("</text>\n");
        template.append("    </view>\n");
        template.append("    \n");
        template.append("    <!-- 在这里添加你的页面内容 -->\n");
        template.append("    <view class=\"custom-content\">\n");
        template.append("      <!-- TODO: 实现具体功能 -->\n");
        template.append("    </view>\n");
        template.append("  </view>\n");
        template.append("</template>\n\n");
        
        template.append("<script>\n");
        template.append("export default {\n");
        template.append("  data() {\n");
        template.append("    return {\n");
        template.append("      // 页面数据\n");
        template.append("    }\n");
        template.append("  },\n");
        template.append("  onLoad(options) {\n");
        template.append("    // 页面加载\n");
        template.append("    console.log('页面加载:', options);\n");
        template.append("  },\n");
        template.append("  onShow() {\n");
        template.append("    // 页面显示\n");
        template.append("  },\n");
        template.append("  onHide() {\n");
        template.append("    // 页面隐藏\n");
        template.append("  },\n");
        template.append("  methods: {\n");
        template.append("    // 页面方法\n");
        template.append("  }\n");
        template.append("}\n");
        template.append("</script>\n\n");
        
        template.append("<style scoped>\n");
        template.append(".container {\n");
        template.append("  padding: 20rpx;\n");
        template.append("  min-height: 100vh;\n");
        template.append("  background-color: #f8f8f8;\n");
        template.append("}\n\n");
        template.append(".page-header {\n");
        template.append("  text-align: center;\n");
        template.append("  padding: 40rpx 0;\n");
        template.append("  background: linear-gradient(135deg, #409EFF 0%, #764ba2 100%);\n");
        template.append("  border-radius: 20rpx;\n");
        template.append("  margin-bottom: 30rpx;\n");
        template.append("}\n\n");
        template.append(".page-title {\n");
        template.append("  font-size: 36rpx;\n");
        template.append("  font-weight: bold;\n");
        template.append("  color: #ffffff;\n");
        template.append("}\n\n");
        template.append(".page-content {\n");
        template.append("  background: #ffffff;\n");
        template.append("  border-radius: 15rpx;\n");
        template.append("  padding: 30rpx;\n");
        template.append("  margin-bottom: 30rpx;\n");
        template.append("  box-shadow: 0 2rpx 10rpx rgba(0, 0, 0, 0.1);\n");
        template.append("}\n\n");
        template.append(".welcome-text {\n");
        template.append("  display: block;\n");
        template.append("  font-size: 32rpx;\n");
        template.append("  color: #333333;\n");
        template.append("  margin-bottom: 20rpx;\n");
        template.append("  font-weight: 500;\n");
        template.append("}\n\n");
        template.append(".page-info {\n");
        template.append("  display: block;\n");
        template.append("  font-size: 28rpx;\n");
        template.append("  color: #666666;\n");
        template.append("  margin-bottom: 15rpx;\n");
        template.append("}\n\n");
        template.append(".created-time {\n");
        template.append("  display: block;\n");
        template.append("  font-size: 24rpx;\n");
        template.append("  color: #999999;\n");
        template.append("}\n\n");
        template.append(".custom-content {\n");
        template.append("  background: #ffffff;\n");
        template.append("  border-radius: 15rpx;\n");
        template.append("  padding: 30rpx;\n");
        template.append("  min-height: 300rpx;\n");
        template.append("  box-shadow: 0 2rpx 10rpx rgba(0, 0, 0, 0.1);\n");
        template.append("}\n");
        template.append("</style>\n");
        
        return template.toString();
    }

    /**
     * 更新tabBar配置
     */
    private void updateTabBarConfig(JSONObject pagesJson, List<SysUniappPage> enabledPages) {
        // 获取当前tabBar配置，如果不存在则创建默认配置
        JSONObject tabBar = pagesJson.getJSONObject("tabBar");
        if (tabBar == null) {
            tabBar = new JSONObject();
            tabBar.put("color", "#999999");
            tabBar.put("selectedColor", "#409EFF");
            tabBar.put("borderStyle", "black");
            tabBar.put("backgroundColor", "#ffffff");
            tabBar.put("list", new JSONArray());
        }

        // 获取现有的tabBar列表
        JSONArray tabBarList = tabBar.getJSONArray("list");
        if (tabBarList == null) {
            tabBarList = new JSONArray();
        }

        // 直接获取设置为底部导航的页面，并按排序字段排序
        List<SysUniappPage> tabBarPages = selectTabbarPagesList();

        // 重新构建tabBar列表
        JSONArray newTabBarList = new JSONArray();
        for (SysUniappPage page : tabBarPages) {
            JSONObject tabBarItem = new JSONObject();
            tabBarItem.put("pagePath", page.getPagePath());
            
            // 设置tabBar文本，优先使用tabbarText，否则使用pageTitle
            String tabBarText = StringUtils.isNotEmpty(page.getTabbarText()) 
                ? page.getTabbarText() 
                : page.getPageTitle();
            tabBarItem.put("text", tabBarText);

            // 设置图标路径
            if (StringUtils.isNotEmpty(page.getTabbarIconPath())) {
                tabBarItem.put("iconPath", page.getTabbarIconPath());
            }

            // 设置选中状态图标路径
            if (StringUtils.isNotEmpty(page.getTabbarSelectedIcon())) {
                tabBarItem.put("selectedIconPath", page.getTabbarSelectedIcon());
            }
            
            newTabBarList.add(tabBarItem);
        }

        // 更新tabBar配置
        tabBar.put("list", newTabBarList);
        pagesJson.put("tabBar", tabBar);
        
        log.info("tabBar配置更新完成，共{}个底部导航页面", newTabBarList.size());
    }

    /**
     * 查询TabBar页面列表，按排序字段排序
     *
     * @return TabBar页面集合
     */
    @Override
    public List<SysUniappPage> selectTabbarPagesList()
    {
        return sysUniappPageMapper.selectTabbarPagesList();
    }

    /**
     * 获取页面代码内容
     *
     * @param pagePath 页面路径
     * @return 页面代码内容
     */
    @Override
    public String getPageCode(String pagePath)
    {
        try {
            log.info("获取页面代码: {}", pagePath);

            // 验证页面路径
            if (!validatePagePath(pagePath)) {
                log.error("页面路径格式不正确: {}", pagePath);
                return null;
            }

            // 构建页面文件路径
            Path projectPath = Paths.get(uniappProjectPath).toAbsolutePath();
            Path pageFilePath = projectPath.resolve(pagePath + ".vue");

            // 检查文件是否存在
            if (!Files.exists(pageFilePath)) {
                log.warn("页面文件不存在: {}", pageFilePath);
                return null;
            }

            // 读取文件内容 (保持原始格式)
            byte[] fileBytes = Files.readAllBytes(pageFilePath);
            String content = new String(fileBytes, StandardCharsets.UTF_8);
            log.info("成功读取页面代码，文件大小: {} 字符", content.length());

            return content;

        } catch (Exception e) {
            log.error("获取页面代码失败: {}", e.getMessage(), e);
            return null;
        }
    }

    /**
     * 保存页面代码内容
     *
     * @param pagePath 页面路径
     * @param code 页面代码内容
     * @return 保存结果
     */
    @Override
    public boolean savePageCode(String pagePath, String code)
    {
        try {
            log.info("保存页面代码: {}", pagePath);

            // 验证页面路径
            if (!validatePagePath(pagePath)) {
                log.error("页面路径格式不正确: {}", pagePath);
                return false;
            }

            // 验证代码内容
            if (StringUtils.isEmpty(code)) {
                log.error("页面代码内容不能为空");
                return false;
            }

            // 构建页面文件路径
            Path projectPath = Paths.get(uniappProjectPath).toAbsolutePath();
            Path pageFilePath = projectPath.resolve(pagePath + ".vue");

            // 检查文件是否存在
            if (!Files.exists(pageFilePath)) {
                log.error("页面文件不存在: {}", pageFilePath);
                return false;
            }

            // 备份原文件到统一备份目录
            Path backupDir = createBackupDirectory("pages");
            String timestamp = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
            String backupFileName = pagePath.replace("/", "_") + "." + timestamp + ".backup";
            Path backupPath = backupDir.resolve(backupFileName);
            Files.copy(pageFilePath, backupPath, StandardCopyOption.REPLACE_EXISTING);
            log.info("已备份原文件到: {}", backupPath);

            // 保存新内容 (保持原始格式)
            System.out.println(code);
            byte[] codeBytes = code.getBytes(StandardCharsets.UTF_8);
            Files.write(pageFilePath, codeBytes);
            log.info("页面代码保存成功，文件大小: {} 字符", code.length());

            // 验证保存结果
            byte[] savedBytes = Files.readAllBytes(pageFilePath);
            String savedContent = new String(savedBytes, StandardCharsets.UTF_8);
            log.info("保存验证 - 包含template标签: {}", savedContent.contains("<template>"));
            log.info("保存验证 - 包含view标签: {}", savedContent.contains("<view>"));
            log.info("保存验证 - 文件大小: {} 字符", savedContent.length());

            return true;

        } catch (Exception e) {
            log.error("保存页面代码失败: {}", e.getMessage(), e);
            return false;
        }
    }

    /**
     * 从备份文件恢复页面代码
     *
     * @param pagePath 页面路径
     * @param backupFileName 备份文件名
     * @return 恢复结果
     */
    @Override
    public boolean restoreFromBackup(String pagePath, String backupFileName)
    {
        try {
            log.info("从备份恢复页面代码: {} <- {}", pagePath, backupFileName);

            // 验证页面路径
            if (!validatePagePath(pagePath)) {
                log.error("页面路径格式不正确: {}", pagePath);
                return false;
            }

            // 构建文件路径
            Path projectPath = Paths.get(uniappProjectPath).toAbsolutePath();
            Path pageFilePath = projectPath.resolve(pagePath + ".vue");

            // 在统一备份目录中查找备份文件
            Path backupDir = createBackupDirectory("pages");
            Path backupFilePath = backupDir.resolve(backupFileName);

            // 检查备份文件是否存在
            if (!Files.exists(backupFilePath)) {
                log.error("备份文件不存在: {}", backupFilePath);
                return false;
            }

            // 检查原文件是否存在
            if (!Files.exists(pageFilePath)) {
                log.error("原页面文件不存在: {}", pageFilePath);
                return false;
            }

            // 先备份当前文件到统一备份目录
            String timestamp = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
            String currentBackupFileName = pagePath.replace("/", "_") + ".before-restore." + timestamp + ".backup";
            Path currentBackupPath = backupDir.resolve(currentBackupFileName);
            Files.copy(pageFilePath, currentBackupPath, StandardCopyOption.REPLACE_EXISTING);
            log.info("当前文件已备份到: {}", currentBackupPath);

            // 从备份文件恢复
            Files.copy(backupFilePath, pageFilePath, StandardCopyOption.REPLACE_EXISTING);
            log.info("成功从备份文件恢复页面代码");

            return true;

        } catch (Exception e) {
            log.error("从备份恢复页面代码失败: {}", e.getMessage(), e);
            return false;
        }
    }

    /**
     * 获取页面的备份文件列表
     *
     * @param pagePath 页面路径
     * @return 备份文件列表
     */
    @Override
    public List<String> getPageBackupFiles(String pagePath)
    {
        List<String> backupFiles = new ArrayList<>();
        try {
            Path backupDir = createBackupDirectory("pages");
            if (!Files.exists(backupDir)) {
                return backupFiles;
            }

            String pagePrefix = pagePath.replace("/", "_");
            Files.list(backupDir)
                .filter(Files::isRegularFile)
                .filter(path -> path.getFileName().toString().startsWith(pagePrefix))
                .sorted((p1, p2) -> p2.getFileName().toString().compareTo(p1.getFileName().toString())) // 按时间倒序
                .forEach(path -> backupFiles.add(path.getFileName().toString()));

        } catch (Exception e) {
            log.error("获取页面备份文件列表失败: {}", e.getMessage(), e);
        }
        return backupFiles;
    }

    /**
     * 获取pages.json的备份文件列表
     *
     * @return 备份文件列表
     */
    @Override
    public List<String> getPagesJsonBackupFiles()
    {
        List<String> backupFiles = new ArrayList<>();
        try {
            Path backupDir = createBackupDirectory("pages.json");
            if (!Files.exists(backupDir)) {
                return backupFiles;
            }

            Files.list(backupDir)
                .filter(Files::isRegularFile)
                .filter(path -> path.getFileName().toString().startsWith("pages.json"))
                .sorted((p1, p2) -> p2.getFileName().toString().compareTo(p1.getFileName().toString())) // 按时间倒序
                .forEach(path -> backupFiles.add(path.getFileName().toString()));

        } catch (Exception e) {
            log.error("获取pages.json备份文件列表失败: {}", e.getMessage(), e);
        }
        return backupFiles;
    }

    /**
     * 清理指定天数之前的备份文件
     *
     * @param days 保留天数
     * @return 清理结果
     */
    @Override
    public boolean cleanOldBackups(int days)
    {
        try {
            Path backupBaseDir = Paths.get(uniappProjectPath).resolve("backups");
            if (!Files.exists(backupBaseDir)) {
                return true;
            }

            long cutoffTime = System.currentTimeMillis() - (days * 24L * 60L * 60L * 1000L);
            int deletedCount = 0;

            // 清理pages目录
            Path pagesBackupDir = backupBaseDir.resolve("pages");
            if (Files.exists(pagesBackupDir)) {
                deletedCount += cleanBackupDirectory(pagesBackupDir, cutoffTime);
            }

            // 清理pages.json目录
            Path pagesJsonBackupDir = backupBaseDir.resolve("pages.json");
            if (Files.exists(pagesJsonBackupDir)) {
                deletedCount += cleanBackupDirectory(pagesJsonBackupDir, cutoffTime);
            }

            log.info("清理备份文件完成，删除{}个过期备份文件", deletedCount);
            return true;

        } catch (Exception e) {
            log.error("清理备份文件失败: {}", e.getMessage(), e);
            return false;
        }
    }

    /**
     * 清理指定目录中的过期备份文件
     *
     * @param backupDir 备份目录
     * @param cutoffTime 截止时间
     * @return 删除的文件数量
     */
    private int cleanBackupDirectory(Path backupDir, long cutoffTime) throws IOException
    {
        int deletedCount = 0;
        try {
            deletedCount = (int) Files.list(backupDir)
                .filter(Files::isRegularFile)
                .filter(path -> {
                    try {
                        return Files.getLastModifiedTime(path).toMillis() < cutoffTime;
                    } catch (IOException e) {
                        return false;
                    }
                })
                .peek(path -> {
                    try {
                        Files.delete(path);
                        log.debug("删除过期备份文件: {}", path);
                    } catch (IOException e) {
                        log.warn("删除备份文件失败: {}", path, e);
                    }
                })
                .count();
        } catch (IOException e) {
            log.error("遍历备份目录失败: {}", backupDir, e);
        }
        return deletedCount;
    }
}
