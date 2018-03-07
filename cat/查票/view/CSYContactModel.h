//
//  CSYContactModel.h
//  cat
//
//  Created by hongchen on 2018/3/4.
//  Copyright © 2018年 hongchen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSYContactModel : NSObject

/** 乘客类型（成人、学生...） */
@property (strong,nonatomic) NSString * passenger_type_name;

/** <#注释#> */
@property (strong,nonatomic) NSString * code;

/** <#注释#> */
@property (strong,nonatomic) NSString * country_code;

/** 性别（0/1） */
@property (strong,nonatomic) NSString * sex_code;

/** 姓名 */
@property (strong,nonatomic) NSString * passenger_name;

/** <#注释#> */
@property (strong,nonatomic) NSString * sex_name;

/** <#注释#> */
@property (strong,nonatomic) NSString * passenger_flag;


@property (strong,nonatomic) NSString * passenger_id_type_name;

/** <#注释#> */
@property (strong,nonatomic) NSString * passenger_id_type_code;

/** <#注释#> */
@property (strong,nonatomic) NSString * recordCount;

/** <#注释#> */
@property (strong,nonatomic) NSString * mobile_no;

/** <#注释#> */
@property (strong,nonatomic) NSString * index_id;

/** 手机号 */
@property (strong,nonatomic) NSString * phone_no;

/** 身份证 */
@property (strong,nonatomic) NSString * passenger_id_no;

/** 邮件 */
@property (strong,nonatomic) NSString * email;

/** <#注释#> */
@property (strong,nonatomic) NSString * postalcode;

/** <#注释#> */
@property (strong,nonatomic) NSString * first_letter;

/** <#注释#> */
@property (strong,nonatomic) NSString * total_times;

/** <#注释#> */
@property (strong,nonatomic) NSString * born_date;

/** <#注释#> */
@property (strong,nonatomic) NSString * address;

/** <#注释#> */
@property (strong,nonatomic) NSString * passenger_type;

/** 用户账号 */
@property (strong,nonatomic) NSString * user;
/** 用户密码 */
@property (strong,nonatomic) NSString * pass;
/** 用户状态 */
@property (strong,nonatomic) NSString * userState;
/** 联系人数量 */
@property (strong,nonatomic) NSString *  count;


@end
