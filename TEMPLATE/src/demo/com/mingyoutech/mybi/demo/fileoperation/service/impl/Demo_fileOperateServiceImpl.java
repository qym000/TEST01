package com.mingyoutech.mybi.demo.fileoperation.service.impl;

import java.util.List;

import org.springframework.stereotype.Service;

import com.mingyoutech.framework.service.impl.BaseServiceImpl;
import com.mingyoutech.mybi.demo.fileoperation.domain.Demo_fileOperate;
import com.mingyoutech.mybi.demo.fileoperation.service.Demo_fileOperateService;

@SuppressWarnings("unchecked")
@Service
public class Demo_fileOperateServiceImpl extends BaseServiceImpl implements
        Demo_fileOperateService {


    public List<Demo_fileOperate> getList(Demo_fileOperate demo_fileOperate)
    {
        return this.find("com.mingyoutech.mybi.demo.fileoperation.domain.Demo_fileOperate.findFileOperateList", demo_fileOperate);
    }
}
