package com.yaoliyun.system.service.impl;

import java.math.BigDecimal;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.util.StringUtils;
import org.springframework.web.client.RestTemplate;
import com.alibaba.fastjson2.JSON;
import com.yaoliyun.common.utils.SecurityUtils;
import com.yaoliyun.system.domain.GarbageRecognitionRecord;
import com.yaoliyun.system.domain.vo.GarbageRecognitionRequest;
import com.yaoliyun.system.domain.vo.GarbageRecognitionResponse;
import com.yaoliyun.system.domain.vo.GarbageSearchRequest;
import com.yaoliyun.system.domain.vo.GarbageSearchResponse;
import com.yaoliyun.system.service.IGarbageRecognitionRecordService;
import com.yaoliyun.system.service.IGarbageRecognitionService;

/**
 * 垃圾识别Service业务层处理
 * 
 * @author ruoyi
 * @date 2025-12-16
 */
@Service
public class GarbageRecognitionServiceImpl implements IGarbageRecognitionService
{
    private static final Logger log = LoggerFactory.getLogger(GarbageRecognitionServiceImpl.class);

    /** 天行API图像识别接口地址 */
    private static final String API_URL = "https://apis.tianapi.com/imglajifenlei/index";

    /** 天行API名称查询接口地址 */
    private static final String SEARCH_API_URL = "https://apis.tianapi.com/lajifenlei/index";

    /** API密钥 */
    private static final String API_KEY = "fd508b34af3b4cfe41937423ffe6cce6";

    /** 垃圾分类名称映射 */
    private static final Map<Integer, String> GARBAGE_TYPE_MAP = new HashMap<>();

    static
    {
        GARBAGE_TYPE_MAP.put(0, "可回收垃圾");
        GARBAGE_TYPE_MAP.put(1, "有害垃圾");
        GARBAGE_TYPE_MAP.put(2, "厨余垃圾(湿垃圾)");
        GARBAGE_TYPE_MAP.put(3, "其他垃圾(干垃圾)");
        GARBAGE_TYPE_MAP.put(4, "未知结果");
    }

    private final RestTemplate restTemplate = new RestTemplate();

    @Autowired
    private IGarbageRecognitionRecordService garbageRecognitionRecordService;

    /**
     * 根据图像识别垃圾分类
     * 
     * @param request 识别请求参数
     * @return 识别结果
     */
    @Override
    public GarbageRecognitionResponse recognizeGarbage(GarbageRecognitionRequest request)
    {
        GarbageRecognitionResponse response;
        String imageUrl = null;
        
        if (StringUtils.hasText(request.getImg()))
        {
            response = recognizeByBase64(request.getImg(), request.getMode());
        }
        else if (StringUtils.hasText(request.getImgurl()))
        {
            imageUrl = request.getImgurl();
            response = recognizeByUrl(request.getImgurl(), request.getMode());
        }
        else
        {
            response = new GarbageRecognitionResponse();
            response.setCode(400);
            response.setMsg("请提供图片base64编码或图片URL");
            return response;
        }
        
        // 识别成功后保存第一个结果到记录表
        saveRecognitionRecord(response, imageUrl, request.getSource());
        
        return response;
    }

    /**
     * 保存识别记录
     * 
     * @param response 识别结果
     * @param imageUrl 图片URL
     * @param source 识别来源
     */
    private void saveRecognitionRecord(GarbageRecognitionResponse response, String imageUrl, String source)
    {
        try
        {
            // 只有识别成功且有结果时才保存
            if (response != null && response.getCode() != null && response.getCode() == 200
                    && response.getResult() != null && response.getResult().getList() != null
                    && !response.getResult().getList().isEmpty())
            {
                GarbageRecognitionResponse.GarbageItem firstItem = response.getResult().getList().get(0);
                
                GarbageRecognitionRecord record = new GarbageRecognitionRecord();
                
                // 设置用户ID
                try
                {
                    record.setUserId(SecurityUtils.getUserId());
                }
                catch (Exception e)
                {
                    log.warn("获取当前用户ID失败", e);
                }
                
                // 设置图片URL
                record.setImageUrl(imageUrl);
                
                // 设置识别结果
                record.setRecognizedName(firstItem.getName());
                record.setCategoryId(firstItem.getLajitype() != null ? firstItem.getLajitype().longValue() : null);
                record.setCategoryName(firstItem.getLajitypeName());
                
                // 设置置信度
                if (firstItem.getTrust() != null)
                {
                    record.setConfidenceScore(new BigDecimal(firstItem.getTrust()));
                }
                
                // 设置识别来源（1拍照 2相册）
                record.setRecognitionSource(StringUtils.hasText(source) ? source : "1");
                
                // 设置识别时间
                record.setRecognitionTime(new Date());
                garbageRecognitionRecordService.insertGarbageRecognitionRecord(record);
                log.info("识别记录保存成功: {}", firstItem.getName());
            }
        }
        catch (Exception e)
        {
            log.error("保存识别记录失败", e);
        }
    }

    /**
     * 根据图片base64识别垃圾分类
     * 
     * @param imgBase64 图片base64编码
     * @param mode 识别模式（0严格模式，1模糊模式）
     * @return 识别结果
     */
    @Override
    public GarbageRecognitionResponse recognizeByBase64(String imgBase64, Integer mode)
    {
        MultiValueMap<String, String> params = new LinkedMultiValueMap<>();
        params.add("key", API_KEY);
        // 不要手动URLEncoder.encode，RestTemplate会自动处理
        params.add("img", imgBase64);
        if (mode != null)
        {
            params.add("mode", String.valueOf(mode));
        }
        return callApi(params);
    }

    /**
     * 根据图片URL识别垃圾分类
     * 
     * @param imgUrl 图片URL地址
     * @param mode 识别模式（0严格模式，1模糊模式）
     * @return 识别结果
     */
    @Override
    public GarbageRecognitionResponse recognizeByUrl(String imgUrl, Integer mode)
    {
        MultiValueMap<String, String> params = new LinkedMultiValueMap<>();
        params.add("key", API_KEY);
        // 不要手动URLEncoder.encode，RestTemplate会自动处理
        params.add("imgurl", imgUrl);
        if (mode != null)
        {
            params.add("mode", String.valueOf(mode));
        }
        return callApi(params);
    }

    /**
     * 调用天行API
     * 
     * @param params 请求参数
     * @return 识别结果
     */
    private GarbageRecognitionResponse callApi(MultiValueMap<String, String> params)
    {
        try
        {
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

            HttpEntity<MultiValueMap<String, String>> requestEntity = new HttpEntity<>(params, headers);

            ResponseEntity<String> responseEntity = restTemplate.postForEntity(API_URL, requestEntity, String.class);

            String responseBody = responseEntity.getBody();
            log.info("垃圾识别API响应: {}", responseBody);

            GarbageRecognitionResponse response = JSON.parseObject(responseBody, GarbageRecognitionResponse.class);

            // 设置垃圾分类名称
            if (response != null && response.getResult() != null && response.getResult().getList() != null)
            {
                for (GarbageRecognitionResponse.GarbageItem item : response.getResult().getList())
                {
                    item.setLajitypeName(GARBAGE_TYPE_MAP.getOrDefault(item.getLajitype(), "未知"));
                }
            }

            return response;
        }
        catch (Exception e)
        {
            log.error("调用垃圾识别API异常", e);
            GarbageRecognitionResponse response = new GarbageRecognitionResponse();
            response.setCode(500);
            response.setMsg("调用垃圾识别API异常: " + e.getMessage());
            return response;
        }
    }

    /**
     * 根据物品名称查询垃圾分类
     * 
     * @param request 查询请求参数
     * @return 查询结果
     */
    @Override
    public GarbageSearchResponse searchByName(GarbageSearchRequest request)
    {
        if (!StringUtils.hasText(request.getWord()))
        {
            GarbageSearchResponse response = new GarbageSearchResponse();
            response.setCode(400);
            response.setMsg("请提供废弃物名称");
            return response;
        }
        return searchByName(request.getWord(), request.getNum(), request.getMode(), request.getPage());
    }

    /**
     * 根据物品名称查询垃圾分类
     * 
     * @param word 废弃物名称
     * @param num 返回数量
     * @param mode 查询模式（0模糊查询，1精确查询）
     * @param page 翻页
     * @return 查询结果
     */
    @Override
    public GarbageSearchResponse searchByName(String word, Integer num, Integer mode, Integer page)
    {
        try
        {
            // 使用POST请求，application/x-www-form-urlencoded格式
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

            MultiValueMap<String, String> params = new LinkedMultiValueMap<>();
            params.add("key", API_KEY);
            params.add("word", word);
            if (num != null)
            {
                params.add("num", num.toString());
            }
            if (mode != null)
            {
                params.add("mode", mode.toString());
            }
            if (page != null)
            {
                params.add("page", page.toString());
            }

            HttpEntity<MultiValueMap<String, String>> requestEntity = new HttpEntity<>(params, headers);
            ResponseEntity<String> responseEntity = restTemplate.postForEntity(SEARCH_API_URL, requestEntity, String.class);
            String responseBody = responseEntity.getBody();
            
            log.info("垃圾分类查询API响应: {}", responseBody);

            GarbageSearchResponse response = JSON.parseObject(responseBody, GarbageSearchResponse.class);

            // 设置垃圾分类名称
            if (response != null && response.getResult() != null && response.getResult().getList() != null)
            {
                for (GarbageSearchResponse.GarbageInfo item : response.getResult().getList())
                {
                    item.setTypeName(GARBAGE_TYPE_MAP.getOrDefault(item.getType(), "未知"));
                }
            }

            return response;
        }
        catch (Exception e)
        {
            log.error("调用垃圾分类查询API异常", e);
            GarbageSearchResponse response = new GarbageSearchResponse();
            response.setCode(500);
            response.setMsg("调用垃圾分类查询API异常: " + e.getMessage());
            return response;
        }
    }
}
