package com.yaoliyun.system.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import com.yaoliyun.common.annotation.Log;
import com.yaoliyun.common.core.controller.BaseController;
import com.yaoliyun.common.core.domain.AjaxResult;
import com.yaoliyun.common.enums.BusinessType;
import com.yaoliyun.system.domain.vo.GarbageRecognitionRequest;
import com.yaoliyun.system.domain.vo.GarbageRecognitionResponse;
import com.yaoliyun.system.domain.vo.GarbageSearchRequest;
import com.yaoliyun.system.domain.vo.GarbageSearchResponse;
import com.yaoliyun.system.service.IGarbageRecognitionService;

/**
 * 垃圾识别Controller
 * 
 * @author ruoyi
 * @date 2025-12-16
 */
@RestController
@RequestMapping("/system/recognition")
public class GarbageRecognitionController extends BaseController
{
    @Autowired
    private IGarbageRecognitionService garbageRecognitionService;

    /**
     * 根据图像识别垃圾分类
     * 支持base64编码或图片URL
     * 
     * @param request 识别请求参数
     * @return 识别结果
     */
    @Log(title = "垃圾识别", businessType = BusinessType.OTHER)
    @PostMapping("/recognize")
    public AjaxResult recognize(@RequestBody GarbageRecognitionRequest request)
    {
        GarbageRecognitionResponse response = garbageRecognitionService.recognizeGarbage(request);
        if (response.getCode() != null && response.getCode() == 200)
        {
            return success(response.getResult());
        }
        else
        {
            return error(response.getMsg());
        }
    }

    /**
     * 根据图片base64识别垃圾分类
     * 
     * @param img 图片base64编码
     * @param mode 识别模式（0严格模式，1模糊模式），可选
     * @return 识别结果
     */
    @Log(title = "垃圾识别-Base64", businessType = BusinessType.OTHER)
    @PostMapping("/recognizeByBase64")
    public AjaxResult recognizeByBase64(@RequestParam("img") String img,
                                        @RequestParam(value = "mode", required = false) Integer mode)
    {
        GarbageRecognitionResponse response = garbageRecognitionService.recognizeByBase64(img, mode);
        if (response.getCode() != null && response.getCode() == 200)
        {
            return success(response.getResult());
        }
        else
        {
            return error(response.getMsg());
        }
    }

    /**
     * 根据图片URL识别垃圾分类
     * 
     * @param imgurl 图片URL地址（支持jpg/png/bmp格式）
     * @param mode 识别模式（0严格模式，1模糊模式），可选
     * @return 识别结果
     */
    @Log(title = "垃圾识别-URL", businessType = BusinessType.OTHER)
    @PostMapping("/recognizeByUrl")
    public AjaxResult recognizeByUrl(@RequestParam("imgurl") String imgurl,
                                     @RequestParam(value = "mode", required = false) Integer mode)
    {
        GarbageRecognitionResponse response = garbageRecognitionService.recognizeByUrl(imgurl, mode);
        if (response.getCode() != null && response.getCode() == 200)
        {
            return success(response.getResult());
        }
        else
        {
            return error(response.getMsg());
        }
    }

    /**
     * 根据物品名称查询垃圾分类
     * 
     * @param request 查询请求参数
     * @return 查询结果
     */
    @Log(title = "垃圾分类查询", businessType = BusinessType.OTHER)
    @PostMapping("/search")
    public AjaxResult search(@RequestBody GarbageSearchRequest request)
    {
        GarbageSearchResponse response = garbageRecognitionService.searchByName(request);
        if (response.getCode() != null && response.getCode() == 200)
        {
            return success(response.getResult());
        }
        else if (response.getCode() != null && response.getCode() == 250)
        {
            // 数据为空，返回空结果
            GarbageSearchResponse.Result emptyResult = new GarbageSearchResponse.Result();
            emptyResult.setList(new java.util.ArrayList<>());
            emptyResult.setTotal(Integer.valueOf(0));
            return success(emptyResult);
        }
        else
        {
            return error(response.getMsg());
        }
    }

    /**
     * 根据物品名称查询垃圾分类（GET方式）
     * 
     * @param word 废弃物名称
     * @param num 返回数量，可选
     * @param mode 查询模式（0模糊查询，1精确查询），可选
     * @param page 翻页，可选
     * @return 查询结果
     */
    @Log(title = "垃圾分类查询-名称", businessType = BusinessType.OTHER)
    @GetMapping("/searchByName")
    public AjaxResult searchByName(@RequestParam("word") String word,
                                   @RequestParam(value = "num", required = false) Integer num,
                                   @RequestParam(value = "mode", required = false) Integer mode,
                                   @RequestParam(value = "page", required = false) Integer page)
    {
        GarbageSearchResponse response = garbageRecognitionService.searchByName(word, num, mode, page);
        if (response.getCode() != null && response.getCode() == 200)
        {
            return success(response.getResult());
        }
        else if (response.getCode() != null && response.getCode() == 250)
        {
            // 数据为空，返回空结果
            GarbageSearchResponse.Result emptyResult = new GarbageSearchResponse.Result();
            emptyResult.setList(new java.util.ArrayList<>());
            emptyResult.setTotal(Integer.valueOf(0));
            return success(emptyResult);
        }
        else
        {
            return error(response.getMsg());
        }
    }
}
